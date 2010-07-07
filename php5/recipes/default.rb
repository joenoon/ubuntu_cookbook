include_recipe "apt"

%w( python-software-properties php5-cli php5-common php5-suhosin ).each { |x| package x }

execute "add ppa" do
  command "add-apt-repository ppa:brianmercer/php"
  creates "/etc/apt/sources.list.d/brianmercer-php-lucid.list"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

%w( php5-fpm php5-cgi php5-sqlite php5-curl ).each { |x| package x }

ruby_block "edit php config" do
  block do
    conf = Chef::Util::FileEdit.new("/etc/php5/fpm/php5-fpm.conf")
    conf.search_file_replace_line(/^pm\.max_children/, "pm.max_children = #{node[:php5][:max_children]}")
    conf.write_file
  end
  action :create
end

service "php" do
  service_name "php5-fpm"
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end
