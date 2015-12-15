Sysadmin Interview Tech Task
============================

##Part 1

###Overview  
You will have been given credentials to an AWS account. You're task is to create, and configure an instance using a configuration management tool.    
We estimate this should take you about half an hour to 1 hour, but do not worry if you have not finished in that time. This is more to see your way of thinking and working.  
  
1. You may use either **Chef** or **Puppet** as a configuration management tool. Chef is preferred. Choose whichever you feel you can work best with.  
2. Fork this repo in GitHub  
3. Create a **t1.micro** instance inside of AWS, selecting **Ubuntu** as the AMI (you may use any release of your choosing)  
  * You may use CentOS if you prefer Redhat based systems, however Debian based is preferred and Ubuntu is our primary distribution of choice.  
4. Write your cookbook(s)/manifest(s), and commit them to your fork  
5. Configure your instance, and leave it running once you are finished  
  * If you use any 3rd party knife cookbooks or manifests, please include these as well under a separate directory so we can easily see your work. Ideally we should be able to execute a single command to re-run your configuration on a fresh instance rather than pull down 3rd party cookbooks/manifests/plugins.  
    
###Tasks

1. Create a new user on the system called **blogger**  
  * Their home directory should be /home/blogger  
  * Their password should be _wordpresssecuritysucks_  
  * Their shell should be **bash**, or **dash**  
  * Give them sudo access **only** to execute /etc/init.d/hostname  
2. Install **MySQL** server (5.6 or newer)  
  * You may use the package manager, tarball binaries, or source - we may ask your reasons for your chosen install method
  * The MySQL user should be **mysql** with a primary group of **mysql**
  * The data directory should be **/var/lib/mysql**
  * The server daemon should start on boot
  * _Optional: configure the root user's .my.cnf file so they don't need a password on the command line_
3. Install **Apache** and **PHP >= 5.4**
  * _Optional: install/remove any additional PHP modules you feel are beneficial_
  * _Optional: enable/disable any Apache modules you feel are beneficial_
  * Don't worry about tweaking Apache for high traffic - the default configuration will do
  * Use standard ports
4. Install the latest version of WordPress
  * You only need to install up to the point that the installer can be run for this exercise  
  * You must still create a database, user and password for WordPress to use  
  * Install WordPress under the _blogger_ user's home directory, in a subdirectory called "wordpress"  
  * _Optional: configure permissions so that the user and apache users can both read/write to the directory_  
5. Configure Apache to serve the WordPress install over HTTPS  
  * Create yourself a self-signed certificate to use  
  * Use standard ports  
    
    
##Part 2

###Overview
For this task you'll need to have [Vagrant](https://www.vagrantup.com/) installed.  
You will bring up the instance, and have to resolve various problems outlined below.
We estimate this should take you about half an hour to 1 hour to complete. Do not worry if you cannot solve all the problems, this is about seeing how you go about problem solving. We may ask you about your methodologies to finding and solving the problems (Googling is a valid method).  
_Please refrain from inspecting the chef cookbooks to find how the machine was broken until after you have attempted the solutions. You'll only be cheating yourself._
  
1. Either detail your steps in a **STEPS.md** file, or using custom scripts or config management tools write the corrective measures needed for each problem  
2. Commit this new markdown file/script(s)/config management configs, and email us a link to it. Please **don't** open a pull request with your solutions, so that others cannot use it for reference later on  
  
###Problems to fix

1. Unable to ping www.google.com  
2. Unable to successfully run the command `mysql < /tmp/world.sql`  
3. The user _problemz_ cannot write to the file _/home/problemz/tasks.txt_  
4. The disk mounted at _/mnt/saysfullbutnot_ cannot be written to despite claiming to have space available  
5. The user _someadmin_ cannot sudo up to root  
6. The software raid array under /dev/md0 is reporting an error  
7. A server error is produced when loading [http://172.16.2.12](http://172.16.2.12)
