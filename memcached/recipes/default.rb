package "memcached"

service "memcached" do
  supports :start => true, :stop => true, :status => true, :restart => true
  action node[:memcached][:service]
end
