execute "add mongodb key" do
  command "apt-key adv --keyserver keys.gnupg.net --recv 7F0CEB10"
  action :nothing
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

remote_file "/etc/apt/sources.list.d/mongodb.list" do
  source "mongodb.list"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "add mongodb key"), :immediately
end

remote_file "/etc/apt/preferences.d/pin-mongodb" do
  source "pin-mongodb"
  owner "root"
  group "root"
  mode "0644"
end

package "mongodb-stable"

service "mongodb" do
  restart_command "restart mongodb"
  stop_command "stop mongodb"
  start_command "start mongodb"
  supports :status => true, :restart => true, :reload => true
  action [ :start ]
end
