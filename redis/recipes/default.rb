bash "install redis" do
  user "root"
  cwd "/usr/local/src"
  code <<-CODE
    rm -rf /usr/local/src/redis-2.0.2
    tar zxf /usr/local/src/redis-2.0.2.tar.gz
    cd /usr/local/src/redis-2.0.2
    make
    ln -nfs /usr/local/src/redis-2.0.2 /usr/local/redis
  CODE
  action :nothing
end

remote_file "/usr/local/src/redis-2.0.2.tar.gz" do
  source "http://redis.googlecode.com/files/redis-2.0.2.tar.gz"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:bash => "install redis"), :immediately
end

template "/etc/init.d/redis" do
  source "redis.initd.sh"
  mode "0755"
end

service "redis" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/usr/local/redis/redis.conf" do
  source "redis.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "redis")
end

service "redis" do
  action [ :start ]
end
