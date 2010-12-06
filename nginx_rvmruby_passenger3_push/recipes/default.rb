# only tested with rvm

rvm_install node[:nginx_rvmruby_passenger3_push][:ruby_wrapper]

passenger_tgz_file = File.basename(node[:nginx_rvmruby_passenger3_push][:passenger_tgz])
push_tgz_file = File.basename(node[:nginx_rvmruby_passenger3_push][:push_tgz])

remote_file "/usr/local/src/#{passenger_tgz_file}" do
  source node[:nginx_rvmruby_passenger3_push][:passenger_tgz]
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

remote_file "/usr/local/src/#{push_tgz_file}" do
  source node[:nginx_rvmruby_passenger3_push][:push_tgz]
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

bash "install passenger" do
  code %Q{
    . /usr/local/lib/rvm
    set -v
    set -x
    cd /usr/local/src
    tar xzf #{passenger_tgz_file}
    tar xzf #{push_tgz_file}
    set +v
    set +x
    /usr/local/src/#{node[:nginx_rvmruby_passenger3_push][:passenger_extracts_to]}/bin/passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx --extra-configure-flags='--with-http_ssl_module --add-module=/usr/local/src/#{node[:nginx_rvmruby_passenger3_push][:push_extracts_to]}'
    set -v
    set -x
    passenger_root="/usr/local/src/#{node[:nginx_rvmruby_passenger3_push][:passenger_extracts_to]}"
    passenger_ruby=`which ruby`
    mkdir -p /opt/nginx/conf/conf.d
    rm -rf /opt/nginx/conf/conf.d/passenger.conf
    touch /opt/nginx/conf/conf.d/passenger.conf
    echo "passenger_root ${passenger_root};" >> /opt/nginx/conf/conf.d/passenger.conf
    echo "passenger_ruby ${passenger_ruby};" >> /opt/nginx/conf/conf.d/passenger.conf
    chmod 0644 /opt/nginx/conf/conf.d/passenger.conf
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

cookbook_file "/opt/nginx/conf/php5_backend" do
  source "php5_backend"
  backup false
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

service "nginx" do
  action [ :start ]
end
