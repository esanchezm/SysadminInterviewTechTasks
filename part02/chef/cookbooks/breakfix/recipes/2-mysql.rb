package "mysql-server"

service "mysql" do
    action :nothing
end

directory "/var/lib/mysql/World/" do
    action :delete
    recursive true
    notifies :restart, "service[mysql]", :immediately
end

cookbook_file "/tmp/schema.sql" do
    owner "root"
    group "root"
    mode 0644
    source "schema.sql"
end

cookbook_file "/tmp/world.sql" do
    owner "root"
    group "root"
    mode 0644
    source "world.sql"
end

execute "import" do
    command "mysql < /tmp/schema.sql"
end

file "/tmp/schema.sql" do
    action :delete
end

execute "chown -R root:mysql /var/lib/mysql/World/*"
execute "chmod -R 0400 /var/lib/mysql/World/*"

cookbook_file "/etc/mysql/my.cnf" do
    owner "root"
    group "root"
    mode 0644
    source "my.cnf"
    notifies :restart, "service[mysql]", :immediately
end