package "apache2"

disabled_modules = [
    "autoindex",
    "status",
]

disabled_modules.each do |m|
    execute "disable module" do
        command "a2dismod #{m}"
    end
end


# I know it offers at least PHP 5.5 and
# I couldn't specify something like >=5.4
# because chef does it owns tricks wit this
package "php5"

extra_packages = [
    "php5-mysql",
    "php5-xcache",
    "php5-mongo",
    "libapache2-mod-php5",
]

extra_packages.each do |p|
    package p
end
