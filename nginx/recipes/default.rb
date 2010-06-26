package "nginx"

directory @node[:nginx][:log_dir] do
  mode 0755
  owner @node[:nginx][:user]
  action :create
end

directory @node[:nginx][:etc_dir] do
  owner "root"
  group "root"
  mode "0755"
end

%w( sites-available sites-enabled conf.d ).each do |dir|
  directory "#{@node[:nginx][:etc_dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
  end
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

file "/etc/nginx/sites-available/default" do
  action :delete
  backup false
end

execute "rm /etc/nginx/sites-enabled/default" do
  only_if "test -h /etc/nginx/sites-enabled/default"
end

directory "/var/www/nginx-default" do
  owner "root"
  group "root"
  mode 0755
  action :create
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

remote_file "/etc/nginx/fastcgi_params" do
  source "fastcgi_params"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

template "nginx.conf" do
  path "#{node[:nginx][:etc_dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

remote_file "#{node[:nginx][:etc_dir]}/mime.types" do
  source "mime.types"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

remote_file "/etc/nginx/sites-enabled/000-default" do
  source "000-default"
  owner "root"
  group "root"
  mode "0644"
  backup false
  notifies :reload, resources(:service => "nginx")
  not_if "test -f /etc/nginx/sites-enabled/000-default"
end

service "nginx" do
  action [ :enable, :start ]
end
