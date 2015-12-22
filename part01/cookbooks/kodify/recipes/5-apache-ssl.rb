execute "enable apache2 ssl" do
    command "a2enmod ssl"
end

directory "/etc/apache2/ssl" do
    mode '750'
    owner 'www-data'
    group 'www-data'
end

execute "generate ssl cert" do
    command "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=ES/ST=Madrid/L=Madrid/O=Kodify Test/OU=Kodify test/CN=example.com' -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt"
    not_if { File.exist?("/etc/apache2/ssl/apache.crt") }
end

cookbook_file "/etc/apache2/sites-available/blog-ssl.conf" do
    owner "root"
    group "root"
    mode 0644
    source "apache_blogger_ssl.conf"
    notifies :restart, 'service[apache2]'
end

execute 'a2ensite blog-ssl'

service "apache2" do
    action :restart
end
