mount "/mnt/saysfullbutnot" do
    action :umount
    device "/vdisk_fullbutspace"
end

directory "/mnt/saysfullbutnot" do
    owner "root"
    group "root"
    mode 0755
end

execute "create /vdisk_fullbutspace" do
    command "dd if=/dev/zero of=/vdisk_fullbutspace bs=1024 count=1025"
end

bash "loop0" do
    code <<-EOH
        losetup -d #{node['5-fullbutspace']['loopback1']} || true

        set -e

        losetup #{node['5-fullbutspace']['loopback1']} /vdisk_fullbutspace
        mkfs.ext4 #{node['5-fullbutspace']['loopback1']}
    EOH
end

mount "/mnt/saysfullbutnot" do
    device "/vdisk_fullbutspace"
end

bash "scenario5" do
    cwd "/mnt/saysfullbutnot"
    code <<-EOH
        path=$(pwd)

        for((i=0; i >= 0; i++)); do
            path="${path}/${i}"

            mkdir -p "${path}"

            if [[ "$?" != "0" ]]; then
                break;
            fi

            let x="$i % 10"
            if [[ "$x" == "0" ]]; then
                touch "${path}/importantfile"
            fi
        done
    EOH
end