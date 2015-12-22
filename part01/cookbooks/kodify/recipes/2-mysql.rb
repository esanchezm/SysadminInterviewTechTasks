
# I'm installing mysql using package manager because the default
# configuration creates everything you asked for:
#  * It creates a mysql user and group to run the server with it
#  * The default data directory is /var/lib/mysql
#  * The service is started at lunch time
#  * It allow root user to connect without password, thoug I'm adding that file anyway.
package "mysql-server-5.6"

cookbook_file "/root/.my.cnf" do
    owner "root"
    group "root"
    mode 0600
    source "root_my.cnf"
end
