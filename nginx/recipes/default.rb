package "nginx"

service_action_state = node[:nginx].service_action_state

cookbook_file "/etc/nginx/php5_backend" do
  source "php5_backend"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action service_action_state
end
