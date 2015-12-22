execute "apt-get update"

include_recipe "kodify::1-bloggeruser"
include_recipe "kodify::2-mysql"
include_recipe "kodify::3-apache-php"
