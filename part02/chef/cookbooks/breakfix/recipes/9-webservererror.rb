package "nginx"
package "php5-fpm"

service "php5-fpm" do
    action [:enable]
    supports :restart => true, :status => true, :reload => true
end
service "nginx" do
    action [:enable, :restart]
    supports :restart => true, :status => true, :reload => true
end

file "/etc/nginx/sites-enabled/default" do
    action :delete
    notifies :restart, "service[nginx]", :delayed
end

template "/etc/nginx/sites-available/scenario9" do
    owner "root"
    group "root"
    mode 0644
    source "9-webservererror/nginx.conf.erb"
end

link "/etc/nginx/sites-enabled/scenario9" do
    to "/etc/nginx/sites-available/scenario9"
    notifies :restart, "service[nginx]", :delayed
end

template "/etc/php5/fpm/php.ini" do
    owner "root"
    group "root"
    mode 0644
    source "9-webservererror/php.ini.erb"
    notifies :restart, "service[php5-fpm]", :delayed
end

template "/etc/php5/fpm/pool.d/www.conf" do
    owner "root"
    group "root"
    mode 0644
    source "9-webservererror/www.conf.erb"
    notifies :restart, "service[php5-fpm]", :delayed
    notifies :restart, "service[nginx]", :delayed
end

directory node['9-webservererror']['root']

file "#{node['9-webservererror']['root']}/index.php" do
    content "<?php phpinfo();"
    owner "www-data"
    group "www-data"
    mode 0600
end