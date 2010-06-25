service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

include_recipe "brightbox"

package "nginx-brightbox"

file "/etc/nginx/sites-available/default" do
  action :delete
  backup false
end

execute "enable default" do
  command "ln -nfs /etc/nginx/sites-available/000-default /etc/nginx/sites-enabled/000-default"
  action :nothing
  notifies :restart, resources(:service => "nginx"), :delayed
end

remote_file "/var/www/nginx-default/info.php" do
  source "info.php"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

remote_file "/etc/nginx/php5_backend" do
  source "php5_backend"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

remote_file "/etc/nginx/sites-available/000-default" do
  source "000-default"
  owner "root"
  group "root"
  mode "0644"
  backup false
  notifies :run, resources(:execute => "enable default"), :immediately
end

service "nginx" do
  action [ :enable, :start ]
end
