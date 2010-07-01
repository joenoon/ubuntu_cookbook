version = @node[:postgresql][:version]
pg_hba_conf = @node[:postgresql][:pg_hba_conf]
postgresql_conf = @node[:postgresql][:postgresql_conf]

package "postgresql"
package "postgresql-#{version}-postgis"
package "postgresql-contrib-#{version}"

template pg_hba_conf do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
end

template postgresql_conf do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  variables :options => @node[:postgresql][:config].to_a.select {|x| !x[1].nil? }.sort_by {|x| x[0] }
end

service "postgresql" do
  service_name "postgresql-8.4"
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
  action node[:postgresql][:service]
  if node[:postgresql][:service].include?("enable")
    subscribes :restart, resources(:template => postgresql_conf)
    subscribes :reload, resources(:template => pg_hba_conf)
  end
end
