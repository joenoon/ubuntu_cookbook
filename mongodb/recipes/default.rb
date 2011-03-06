execute "touch /etc/apt/mongo_gpg_key_added" do
  action :nothing
end

execute "add mongo gpg key" do
  command "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
  not_if "test -e /etc/apt/mongo_gpg_key_added"
  notifies :run, resources(:execute => "touch /etc/apt/mongo_gpg_key_added"), :immediately
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

template "/etc/apt/sources.list.d/mongodb.list" do
  source "mongodb.list.erb"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

package "mongodb-#{node[:mongodb][:mongo_branch]}"

service "mongodb" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
