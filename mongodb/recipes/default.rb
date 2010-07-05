include_recipe "apt"

service_action_state = node[:mongodb].service_action_state

execute "add mongodb key" do
  command "apt-key adv --keyserver keys.gnupg.net --recv 7F0CEB10"
  action :nothing
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

cookbook_file "/etc/apt/sources.list.d/mongodb.list" do
  source "mongodb.list"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "add mongodb key"), :immediately
end

cookbook_file "/etc/apt/preferences.d/pin-mongodb" do
  source "pin-mongodb"
  owner "root"
  group "root"
  mode "0644"
end

package "mongodb-stable"

service "mongodb" do
  if File.exist?("/etc/init/mongodb.conf")
    provider Chef::Provider::Service::LucidUpstart
  end
  supports :status => true, :restart => true, :reload => true
  action service_action_state
end
