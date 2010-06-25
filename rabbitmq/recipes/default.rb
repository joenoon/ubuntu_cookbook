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
  action :nothing
end

service "rabbitmq" do
  action [ :enable, :start ]
end
