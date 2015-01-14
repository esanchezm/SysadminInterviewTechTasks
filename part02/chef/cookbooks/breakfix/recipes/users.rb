user_data = data_bag_item("breakfix", "users")

user_data['groups'].each do |name, data|
    group name do
        gid data['gid']
        system false
    end
end

user_data['users'].each do |name, data|
    user name do
        uid data['uid']
        system false
        gid data['gid']
        home data['home']
        shell data['shell']
        supports :manage_home => true
    end

    directory data['home'] do
        action :create
        owner name
        group name
        mode 0755
    end
end