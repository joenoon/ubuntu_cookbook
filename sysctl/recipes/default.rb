service "procps" do
  supports :start => true
  action :nothing
end

template "/etc/sysctl.d/60-performance.conf" do
  source "performance.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :start, resources(:service => "procps"), :immediately
end
