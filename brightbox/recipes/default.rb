include_recipe "apt"

execute "add brightbox key" do
  command "apt-key add /usr/local/src/brightbox-packages.key"
  action :nothing
end

remote_file "/usr/local/src/brightbox-packages.key" do
  source "http://apt.brightbox.net/release.asc"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "add brightbox key"), :immediately
end

remote_file "/etc/apt/sources.list.d/brightbox.list" do
  source "brightbox.list"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

remote_file "/etc/apt/preferences.d/pin-brightbox" do
  source "pin-brightbox"
  owner "root"
  group "root"
  mode "0644"
end
