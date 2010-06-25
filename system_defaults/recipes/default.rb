# set correct time and locale

execute "set system time" do
  command "mv /etc/localtime /etc/localtime.bak && ln -nfs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime"
  creates "/etc/localtime.bak"
  action :run
end

template "/etc/default/locale" do
  source "locale.erb"
end

# set default rc confs

template "/root/.gemrc" do
  source "gemrc.erb"
end

template "/root/.curlrc" do
  source "curlrc.erb"
end

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode "0644"
end
