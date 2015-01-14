package "mdadm"

mount "/mnt/scenario7" do
    action :umount
    device "/dev/md0"
end


execute "array stop conditional" do
    command "mdadm --stop /dev/md0"
    only_if "test -e /dev/md0"
end

directory "/mnt/scenario7" do
    owner "root"
    group "root"
    mode 0755
end

execute "create /vdisk_scenario7_01" do
    command "dd if=/dev/zero of=/vdisk_scenario7_01 bs=1M count=10"
end
execute "create /vdisk_scenario7_02" do
    command "dd if=/dev/zero of=/vdisk_scenario7_02 bs=1M count=10"
end

bash "loop0" do
    code <<-EOH
        set -e

        losetup #{node['7-brokenraid']['loopback1']} /vdisk_scenario7_01
        mkfs.ext4 #{node['7-brokenraid']['loopback1']}
    EOH
    not_if "losetup #{node['7-brokenraid']['loopback1']}"
end

bash "loop1" do
    code <<-EOH
        set -e

        losetup #{node['7-brokenraid']['loopback2']} /vdisk_scenario7_02
        mkfs.ext4 #{node['7-brokenraid']['loopback2']}
    EOH
    not_if "losetup #{node['7-brokenraid']['loopback2']}"
end

execute "create array" do
    command "echo y | mdadm --create /dev/md0 --level=1 --raid-devices=2 #{node['7-brokenraid']['loopback1']} #{node['7-brokenraid']['loopback2']}"
    notifies :run, "execute[mkfs]", :immediately
end

execute "mkfs" do
    command "mkfs.ext4 /dev/md0"
    action :nothing
end

execute "array stop" do
    command "mdadm --stop /dev/md0"
end

execute "array prep" do
    command "dd if=/dev/zero of=#{node['7-brokenraid']['loopback2']} bs=1k count=512"
end

execute "re-assemble array" do
    command "mdadm --assemble --scan"
end

mount "/mnt/scenario7" do
    device "/dev/md0"
end

execute "write a file" do
    command "dd if=/dev/zero of=/mnt/scenario7/a_file bs=1M count=5"
end