# only tested with rvm

rbv = node[:nginx_passenger][:ruby_wrapper]

rvm_install rbv

rvm_gem_package "passenger" do
  action :install
  ruby_wrapper rbv
end

bash "install passenger" do
  code %q{
    . /usr/local/lib/rvm
    passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx --extra-configure-flags='--with-http_ssl_module'
  }
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

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/opt/nginx/conf/nginx.conf" do
  source "nginx.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

bash "passenger config" do
  code %Q{
    . /usr/local/lib/rvm
    passenger_root=`passenger-config --root`
    passenger_ruby="/usr/local/rvm/bin/#{rbv}_ruby"
    echo "passenger_root ${passenger_root};" > /opt/nginx/conf/conf.d/passenger.conf
    echo "passenger_ruby ${passenger_ruby};" >> /opt/nginx/conf/conf.d/passenger.conf
    chmod 0644 /opt/nginx/conf/conf.d/passenger.conf
  }
  creates "/opt/nginx/conf/conf.d/passenger.conf"
  notifies :restart, resources(:service => "nginx")
end

cookbook_file "/opt/nginx/conf/php5_backend" do
  source "php5_backend"
  backup false
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

service "nginx" do
  action [ :start ]
end
