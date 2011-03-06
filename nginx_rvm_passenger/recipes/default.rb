require 'digest/md5'
md5_dir = "passenger-"+Digest::MD5.hexdigest(node[:nginx_rvm_passenger][:passenger_tgz]).to_s

rvm_install node[:nginx_rvm_passenger][:ruby_wrapper]

bash "install passenger" do
  code %Q{
    . /usr/local/lib/rvm
    rvm use #{node[:nginx_rvm_passenger][:ruby_wrapper]}
    mkdir -p #{md5_dir}
    cd #{md5_dir}
    curl -L #{node[:nginx_rvm_passenger][:passenger_tgz]} | tar xzf - --strip-components=1
    bin/passenger-install-nginx-module --auto --auto-download --prefix=#{node[:nginx_rvm_passenger][:prefix]} --extra-configure-flags='--with-http_ssl_module'
    touch chef_complete
  }
  cwd "/usr/local/src"
  not_if "test -e /usr/local/src/#{md5_dir}/chef_complete"
end

directory "#{node[:nginx_rvm_passenger][:prefix]}/conf/conf.d" do
  mode "0755"
end

directory "#{node[:nginx_rvm_passenger][:prefix]}/conf/sites" do
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

template "#{node[:nginx_rvm_passenger][:prefix]}/conf/conf.d/passenger.conf" do
  source "passenger.conf"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
  variables :passenger_root => "/usr/local/src/#{md5_dir}".to_s.strip,
            :passenger_ruby_home => `bash -l -c "echo $MY_RUBY_HOME"`.to_s.strip
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
