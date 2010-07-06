template "/etc/sysctl.d/60-performance.conf" do
  source "performance.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "service procps start" do
  action :nothing
  subscribes :run, resources(:template => "/etc/sysctl.d/60-performance.conf"), :immediately
end
