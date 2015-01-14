template "/etc/nsswitch.conf" do
    owner "root"
    group "root"
    mode 0644
    source "1-ping/nsswitch.conf.erb"
    variables ({
        :hosts    => node['1-ping']['nsswitch']['hosts'],
        :networks => node['1-ping']['nsswitch']['networks']
    })
end

cookbook_file "/etc/hosts" do
    owner "root"
    group "root"
    mode 0644
    source "hosts"
end

cookbook_file "/etc/resolv.conf" do
    owner "root"
    group "root"
    mode 0644
    source "resolv.conf"
end