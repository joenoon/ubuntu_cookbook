%w( wget git-core libpcre3-dev libssl-dev ).each {|x| package(x) }

install_prefix = node[:nginx_stream][:install_prefix]
basename = node[:nginx_stream][:basename]

execute "clone repo" do
  command "git clone #{node[:nginx_stream][:git_repo]} #{node[:nginx_stream][:clone_to]}"
  creates node[:nginx_stream][:clone_to]
end

bash "build and install nginx_stream" do
  cwd node[:nginx_stream][:clone_to]
  environment({
    "TAG" => node[:nginx_stream][:git_tag], 
    "NGINX_VERSION" => node[:nginx_stream][:nginx_version], 
    "INSTALL_PREFIX" => install_prefix,
    "CONFIGURE_OPTIONS" => node[:nginx_stream][:configure_options],
    "MODULE_DIR" => "nginx-push-stream-module"
  })
  code %Q{
    mkdir -p build
    git archive --format=tar --prefix=${MODULE_DIR}/ ${TAG} src config | gzip > build/${MODULE_DIR}-${TAG}.tar.gz
    cd build
    rm -rf nginx-${NGINX_VERSION}*
    wget http://sysoev.ru/nginx/nginx-${NGINX_VERSION}.tar.gz
    tar xzvf nginx-${NGINX_VERSION}.tar.gz
    cd nginx-${NGINX_VERSION}
    tar xzvf ../${MODULE_DIR}-${TAG}.tar.gz
    ./configure --prefix=${INSTALL_PREFIX} ${CONFIGURE_OPTIONS}
    make
    make install
  }
  creates "#{install_prefix}/sbin/nginx"
end

directory "#{install_prefix}/conf/conf.d" do
  mode "0755"
end

template "/etc/init.d/#{basename}" do
  source "nginx.initd.sh"
  mode "0755"
  variables node[:nginx_stream]
end

service basename do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable ]
end

template "#{install_prefix}/conf/nginx.conf" do
  source "nginx.conf"
  mode "0644"
  notifies :restart, resources(:service => basename)
  variables node[:nginx_stream]
end

template "#{install_prefix}/conf/conf.d/push.conf" do
  source "push.conf"
  mode "0644"
  notifies :restart, resources(:service => basename)
  variables node[:nginx_stream]
end

template "#{install_prefix}/conf/conf.d/server_http.conf" do
  source "server.conf"
  mode "0644"
  notifies :restart, resources(:service => basename)
  variables node[:nginx_stream].to_hash.merge(:ssl_config => false, :listen_port => node[:nginx_stream][:port])
end

if node[:nginx_stream][:ssl]
  template "#{install_prefix}/conf/conf.d/server_https.conf" do
    source "server.conf"
    mode "0644"
    notifies :restart, resources(:service => basename)
    variables node[:nginx_stream].to_hash.merge(:ssl_config => true, :listen_port => node[:nginx_stream][:ssl_port])
  end
else
  file "#{install_prefix}/conf/conf.d/server_https.conf" do
    action :delete
  end
end  

service basename do
  action [ :start ]
end
