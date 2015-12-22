package "unzip"

remote_file '/home/blogger/wordpress.zip' do
    source 'https://wordpress.org/latest.zip'
end

execute 'extract wordpress' do
    command 'unzip -f wordpress.zip'
    cwd '/home/blogger'
end

directory '/home/blogger/wordpress' do
    mode '0775'
    group 'www-data'
    recursive true
end

execute 'create wordpress database' do
    command "mysql -e \"CREATE DATABASE IF NOT EXISTS wordpress\""
end

execute 'add wordpress database user' do
    command "mysql -e \"GRANT ALL ON wordpress.* to wordpress@localhost IDENTIFIED BY 'wordpress'\""
end

cookbook_file "/etc/apache2/sites-available/blog.conf" do
    owner "root"
    group "root"
    mode 0644
    source "apache_blogger.conf"
end

execute 'a2dissite 000-default'
execute 'a2ensite blog'

service "apache2" do
    action :restart
end
