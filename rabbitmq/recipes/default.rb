directory "/etc/rabbitmq" do
  action :create
  owner "root"
  group "root"
  mode 0755
end
  
template "/etc/rabbitmq/rabbitmq.conf" do
  source "rabbitmq.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

package "rabbitmq-server" do
  action :install
end

service "rabbitmq" do
  service_name "rabbitmq-server"
  supports :status => true, :restart => true, :reload => true
  action node[:rabbitmq][:service]
  if node[:rabbitmq][:service].include?("enable")
    subscribes :restart, resources(:template => "/etc/rabbitmq/rabbitmq.conf")
  end
end
