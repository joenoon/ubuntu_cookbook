service_action_state = node[:rabbitmq].service_action_state
service_enabled = node[:rabbitmq].service_enabled?

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
  action service_action_state
  if service_enabled
    subscribes :restart, resources(:template => "/etc/rabbitmq/rabbitmq.conf")
  end
end
