directory "/var/cache/local/preseeding" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

execute "preseed mysql-server" do
  command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
  source "mysql-server.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, resources(:execute => "preseed mysql-server"), :immediately
end

directory "/etc/mysql" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

template "/etc/mysql/debian.cnf" do
  source "debian.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
end

package "libmysqlclient-dev"
package "mysql-client"
package "mysql-server"

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "mysql" do
  provider Chef::Provider::Service::LucidUpstart
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/etc/mysql/my.cnf")
end

execute "mysql-install-privileges" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/mysql/grants.sql"
  action :nothing
end

template "/etc/mysql/grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  action :create
  notifies :run, resources(:execute => "mysql-install-privileges"), :immediately
end
