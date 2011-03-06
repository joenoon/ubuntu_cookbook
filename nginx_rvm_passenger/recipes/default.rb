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
    . /usr/local/lib/rvm
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

template "#{node[:nginx_rvm_passenger][:prefix]}/conf/conf.d/passenger.conf" do
  source "passenger.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
  variables :passenger_root => `bash -l -c ". /usr/local/lib/rvm; passenger-config --root`.to_s.strip,
            :passenger_ruby_home => `bash -l -c ". /usr/local/lib/rvm; echo $MY_RUBY_HOME"`.to_s.strip
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
