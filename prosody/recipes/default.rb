include_recipe "apt"

service "prosody" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

execute "add prosody key" do
  command "apt-key add /usr/local/src/prosody-debian-packages.key"
  action :nothing
end

remote_file "/usr/local/src/prosody-debian-packages.key" do
  source "http://prosody.im/files/prosody-debian-packages.key"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "add prosody key"), :immediately
end

remote_file "/etc/apt/sources.list.d/prosody.list" do
  source "prosody.list"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

remote_file "/etc/apt/preferences.d/pin-prosody" do
  source "pin-prosody"
  owner "root"
  group "root"
  mode "0644"
end

package "liblua5.1-event-prosody0"
package "lua-zlib"
package "prosody"

@node[:prosody][:external_modules].each_pair do |mod_name, opts|
  remote_file "#{@node[:prosody][:modules_path]}/#{mod_name}.lua" do
    owner "root"
    group "root"
    source opts[:source]
    mode "0644"
    checksum opts[:checksum] # openssl dgst -sha256
    notifies :reload, resources(:service => "prosody")
  end
end

template "/etc/prosody/prosody.cfg.lua" do
  owner "root"
  group "root"
  source "prosody.cfg.lua.erb"
  mode "0755"
  notifies :restart, resources(:service => "prosody")
end

service "prosody" do
  action [ :enable, :start ]
end
