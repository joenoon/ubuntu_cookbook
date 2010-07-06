user "mongodb" do
  shell "/bin/bash"
end

cookbook_file "/etc/init/mongodb.conf" do
  source "upstart.conf"
  owner "root"
  group "root"
  mode "0644"
end

cookbook_file "/etc/mongodb.conf" do
  source "mongodb.conf"
  owner "root"
  group "root"
  mode "0644"
end

dl_mongo_dir = "mongodb-linux-#{node[:mongodb][:arch]}-#{node[:mongodb][:version]}"
tgz_mongo = "#{dl_mongo_dir}.tgz"
usr_src_file = "/usr/local/src/#{tgz_mongo}"
url_mongo = "http://fastdl.mongodb.org/linux/#{tgz_mongo}"

bash "install mongodb" do
  user "root"
  cwd "/usr/local/src"
  code <<-CODE
    rm -rf #{dl_mongo_dir} /usr/mongodb
    tar zxf #{tgz_mongo}
    mv #{dl_mongo_dir} /usr/mongodb
    ln -nfs /usr/mongodb/bin/mongod /usr/bin/mongod
  CODE
  action :nothing
end

remote_file usr_src_file do
  source url_mongo
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:bash => "install mongodb"), :immediately
end

%w( /var/lib/mongodb /var/log/mongodb ).each do |d|
  directory d do
    owner "mongodb"
    group "mongodb"
    mode "0755"
  end
end

service "mongodb" do
  provider Chef::Provider::Service::LucidUpstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
