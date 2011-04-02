rvm_install node[:nginx_rvm_passenger][:ruby_wrapper]

rvm_gem_package "passenger" do
  action :install
  if node[:nginx_rvm_passenger][:passenger_version]
    version node[:nginx_rvm_passenger][:passenger_version]
  end
  ruby_wrapper node[:nginx_rvm_passenger][:ruby_wrapper]
end

bash "install passenger" do
  code %Q{
    . /usr/local/rvm/scripts/rvm
    rvm use #{node[:nginx_rvm_passenger][:ruby_wrapper]}
    passenger-install-nginx-module --auto --auto-download --prefix=#{node[:nginx_rvm_passenger][:prefix]} --extra-configure-flags='--with-http_ssl_module'
  }
  creates "#{node[:nginx_rvm_passenger][:prefix]}/sbin/nginx"
end

directory "#{node[:nginx_rvm_passenger][:prefix]}/conf/conf.d" do
  mode "0755"
  recursive true
end

directory "#{node[:nginx_rvm_passenger][:prefix]}/conf/sites" do
  mode "0755"
  recursive true
end

template "/etc/init.d/nginx" do
  source "nginx.initd.sh"
  mode "0755"
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable ]
end

bash "cache passenger_root path" do
  code %Q{
    . /usr/local/rvm/scripts/rvm
    rvm use #{node[:nginx_rvm_passenger][:ruby_wrapper]}
    passenger-config --root > #{node[:nginx_rvm_passenger][:prefix]}/cache_passenger_root
  }
end

bash "cache passenger_ruby path" do
  code %Q{
    . /usr/local/rvm/scripts/rvm
    rvm use #{node[:nginx_rvm_passenger][:ruby_wrapper]}
    which ruby > #{node[:nginx_rvm_passenger][:prefix]}/cache_passenger_ruby
  }
end

template "#{node[:nginx_rvm_passenger][:prefix]}/conf/conf.d/passenger.conf" do
  source "passenger.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

template "#{node[:nginx_rvm_passenger][:prefix]}/conf/nginx.conf" do
  source "nginx.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

cookbook_file "#{node[:nginx_rvm_passenger][:prefix]}/conf/php5_backend" do
  source "php5_backend"
  backup false
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

service "nginx" do
  action [ :start ]
end
