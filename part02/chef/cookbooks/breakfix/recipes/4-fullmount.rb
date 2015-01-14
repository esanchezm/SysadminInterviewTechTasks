mount "/mnt/scenario4" do
    action :umount
    device "/tmp/scenario4/vdisk"
end

mount "/tmp/scenario4" do
    action :umount
    device "/vdisk_fullmount1"
end

directory "/tmp/scenario4" do
    owner "root"
    group "root"
    mode 0755
end

directory "/mnt/scenario4" do
    owner "root"
    group "root"
    mode 0755
end

execute "create /vdisk_fullmount1" do
    command "dd if=/dev/zero of=/vdisk_fullmount1 bs=1024 count=1025"
end

bash "loop0" do
    code <<-EOH
        losetup -d #{node['4-fullmount']['loopback1']} || true

        set -e

        losetup #{node['4-fullmount']['loopback1']} /vdisk_fullmount1
        mkfs.ext4 #{node['4-fullmount']['loopback1']}
    EOH
end

mount "/tmp/scenario4" do
    device "/vdisk_fullmount1"
end

execute "create /vdisk_fullmount2" do
    command "dd if=/dev/zero of=/tmp/scenario4/vdisk bs=1024 count=4096"
    returns 1
end

bash "loop1" do
    code <<-EOH
        losetup -d #{node['4-fullmount']['loopback2']} || true

        set -e

        losetup #{node['4-fullmount']['loopback2']} //tmp/scenario4/vdisk
        mkfs.ext4 #{node['4-fullmount']['loopback2']}
    EOH
end

mount "/mnt/scenario4" do
    device "/tmp/scenario4/vdisk"
end


execute "cat /dev/zero > /tmp/scenario4/bloat" do
    returns 1
end