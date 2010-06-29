package "nginx"

remote_file "/etc/nginx/php5_backend" do
  source "php5_backend"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
