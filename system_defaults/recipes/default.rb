# set correct time and locale

execute "set system time" do
  command "mv /etc/localtime /etc/localtime.bak && ln -nfs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime"
  creates "/etc/localtime.bak"
  action :run
end

cookbook_file "/etc/default/locale" do
  source "locale"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/curlrc" do
  source "curlrc"
  owner "root"
  group "root"
  mode "0755"
end

file "/etc/hosts" do
  content node[:system_defaults][:hosts]
  owner "root"
  group "root"
  mode "0644"
end
