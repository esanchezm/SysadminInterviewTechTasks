file "/home/problemz/tasks.txt" do
    owner "problemz"
    group "problemz"
    mode 0644
    action :create
end

execute "problemz" do
    command "chattr +i /home/problemz/tasks.txt"
end