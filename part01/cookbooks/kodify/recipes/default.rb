execute "apt-get update"

include_recipe "kodify::1-bloggeruser"
include_recipe "kodify::2-mysql"
include_recipe "kodify::3-apache-php"
include_recipe "kodify::4-wordpress"
include_recipe "kodify::5-apache-ssl"
