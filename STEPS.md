### Previous steps

First I needed to install VirtualBox in my machine. I'm a vagrant user, but using libvirt provider which is quicker and more reliable. So, considering this is a test in which I have to fix some errors which may depend on the virtualization system, I've been spending 5 minutes installing it in my Fedora. The major problem is that I installed Virtualbox 5.0 and apparently my vagrant version requires <4.3.

### Problems found

1. Unable to ping www.google.com

Just by reading the sentence the first thing that comes to my mind is a DNS problem. So, I'm using `dig` forzing the DNS server  to see if it can resolves before attempting any step.

```dig google.com 8.8.8.8```

No response. I'm pinging the Google DNS server with no response. Let's see the route table which uses 10.0.2.2 as the default gw. Seems ok, but I still have no internet access. I'm bringing down eth1 (the one in 172.26.2.0 network). Now I can ping 8.8.8.8, so I have internet access. I'm not sure about it but it looks like a bug in VirtualBox... I've reloaded the box and I don't need to bring eth1 down. Strange. Also, the /etc/resolv.conf file now has a DNS server setup, so I'm 99% sure it's a virtualbox-fedora issue

I'm pinging google.com and it resolves to 192.168.200.200, private address. The first place I'm looking is `/etc/hosts` and there it is :)

2. Unable to successfully run the command `mysql < /tmp/world.sql`

First of all, that file doesn't exist, but I think that it's because I reloaded the box. As a suggestion for the test, move that file to other place instead of `/tmp` :)

I'm provisioning the machine again so I have that file. I could simply copy that, but I consider it cheating.

I can't connect with the vagrant user, but I suppose that's no what you want me to look or you'd have give me some credentials. Trying as root. But let's take a look at that file first... Ok, no problem on a quick sight...

I ran it and it says that the table is read only. Probably the server is on readonly mode. Let's take a look at the config file.

```
read-only=true
```

I'm commenting that line, restarting MySQL. Now it says that the `World/City.frm` file doesn't exist. I'm going into `/var/lib/mysql/World/` and the files are there. I'm trying to repare the database with `mysqlcheck --repair --databases World` but it keeps saying that the files are missing. Permissions? Yes, they have 600 and root owner. Running `chmod ug+rw *``and restarting MySQL.

Now I can run the `mysql </tmp/world.sql` command.

3. The user _problemz_ cannot write to the file _/home/problemz/tasks.txt_

First of all, let's switch to that user. I'm switching to his home and the file is there with 644 permissions but yes, I can't write on it. Tricky one... If I try to write on it as root it says it's readonly too. The first think I'm thinking of it's that the partition is on readonly, so I take a look at `mount` but that partition is not there and also I can write new files.

Let's take a look at extended attributes with `lsattr` and there it's. It has 'i' flag, let's change it with `chattr`

4. The disk mounted at _/mnt/saysfullbutnot_ cannot be written to despite claiming to have space available

Let's take a look at the device mounted in `/mnt/saysfullbutnot`. It's a ext2 partition file and the attributes shown with `tune2fs -l` says that it has no inodes available. I can also check that with `df -ih` and I can see it only has 128 inodes available.

In order to make more inodes available, the only solution is recreate the disk with increased inode limits.

5. The user _someadmin_ cannot sudo up to root

When you try to use sudo with that user it asks you for a password. I consider that a normal behaviour but I suppose you want this working without password. So I'm creati this file `/etc/sudoers.d/someadmin`

```
someadmin ALL=(ALL) NOPASSWD:ALL
```

6. The software raid array under /dev/md0 is reporting an error

To be honest, I've never mounted any RAID in my life and I don't know where to find the log error. So, I'm googling for any help. The first thing I can see is `mdadm --detail /dev/md0` which and it shows only one disk for the RAID0.

I can see that the working disk is on `/dev/loop6`, so I attached a `/dev/loop7` to the RAID and cross my fingers :)

```
mdadm /dev/md0 -a /dev/loop7
```

I've added a file in `/mnt/scenario7`. If I run  `mdadm --detail /dev/md0` it says that `/dev/loop7` is active. So, I'm going to set `/dev/loop6` as faulty and remove it from the RAID to see if the file was replicated into `loop7` disc. I did that using `-f` and `-r` options. Now the RAID is still working with `loop7` and the file is still there. Thank you Google :)

7. A server error is produced when loading [http://172.16.2.12](http://172.16.2.12)

Let's try curl on that to see what's the problem. It throws a 502 Bad Gateway under a nginx server. So, I'm going directly to the nginx configuration.

I can see a `sites-available/scenario9` file which uses PHP FPM under `/usr/share/scenario9` directory. Let's see what's in there. Nothing of interest.

Let's try to connect to 127.0.0.1:9000 which is where PHP was supposed to be listening. Refused.

I'm diving through PHP configuration and at the end I discover that it has no `listen` directive. I added `listen = 127.0.0.1 9000`, restarted PHP FPM and now the nginx is returning Access denied. At the nginx error file it says that upstream has no access to the file. I'm changing PHP FPM `user` directive to `www-data`

Now, the response is empty. I'm looking at the nginx error file and it says that PHP memory limit has been reached. I can see it's limited to 10k. They said that '64k should be enough', right? Raising at to 64MB just in case :)
