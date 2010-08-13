include_recipe "rvm"

bash "set passenger wrapper" do
  code "rvm default --passenger"
  creates "/usr/local/bin/passenger_ruby"
end

rvm_gem "passenger" do
  action :install
end

execute "install passenger" do
  command "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx --extra-configure-flags='--with-http_ssl_module'"
  creates "/opt/nginx/sbin/nginx"
end

directory "/opt/nginx/conf/conf.d" do
  mode "0755"
end

directory "/opt/nginx/conf/sites" do
  mode "0755"
end

template "/etc/init.d/nginx" do
  source "nginx.initd.sh"
  mode "0755"
end

template "/opt/nginx/conf/nginx.conf" do
  source "nginx.conf"
  mode "0644"
end

template "/opt/nginx/conf/conf.d/passenger.conf" do
  source "passenger.conf"
  mode "0644"
end

cookbook_file "/opt/nginx/conf/php5_backend" do
  source "php5_backend"
  backup false
  mode "0644"
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
