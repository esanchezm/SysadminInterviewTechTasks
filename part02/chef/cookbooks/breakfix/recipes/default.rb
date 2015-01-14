include_recipe "breakfix::users"

execute "apt-get update"

node['breakfix']['scenarios'].each do |scenario|
    log "Including breakfix scenario #{scenario}" do
        level :info
    end

    include_recipe "breakfix::#{scenario}"
end