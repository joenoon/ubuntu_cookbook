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

service "mysql" do
  restart_command "restart mysql"
  stop_command "stop mysql"
  start_command "start mysql"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/mysql/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql"), :immediately
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
  notifies :restart, resources(:service => "mysql"), :immediately
  notifies :run, resources(:execute => "mysql-install-privileges"), :immediately
end

service "mysql" do
  action [ :start ]
end

gem_package "mysql"
