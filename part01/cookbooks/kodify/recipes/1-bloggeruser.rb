user 'blogger' do
  comment 'Create a new user on the system called **blogger**'
  home '/home/blogger'
  shell '/bin/bash'
  password '$6$RySwrvQT$RGtqkHtZy3VY5tYQLWIYl/SQma1u6UX1yK1MpdTBjkcWqtJzrJOriyfu2.qM.SeNPFcYvpf7jigkgEgdFQtJy/'
end

cookbook_file "/etc/sudoers.d/blogger" do
    owner "root"
    group "root"
    mode 0440
    source "blogger_sudo"
end
