include_recipe "apt"

service_action_state = node[:php5].service_action_state

service "php" do
  service_name "php5-fpm"
  supports :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

execute "install libkrb" do
  cwd "/usr/local/src"
  command "dpkg -i libkrb.deb"
  action :nothing
end

execute "install libicu" do
  cwd "/usr/local/src"
  command "dpkg -i libicu.deb"
  action :nothing
end

remote_file "/usr/local/src/libkrb.deb" do
  source "http://us.archive.ubuntu.com/ubuntu/pool/main/k/krb5/libkrb53_1.6.dfsg.4~beta1-5ubuntu2_i386.deb"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
  notifies :run, resources(:execute => "install libkrb"), :immediately
end

remote_file "/usr/local/src/libicu.deb" do
  source "http://us.archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu38_3.8-6ubuntu0.2_i386.deb"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
  notifies :run, resources(:execute => "install libicu"), :immediately
end
  
cookbook_file "/etc/apt/sources.list.d/php5.list" do
  source "php5.list"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

cookbook_file "/etc/apt/preferences.d/pin-php5" do
  source "pin-php5"
  owner "root"
  group "root"
  mode "0644"
end

%w( php5-cli php5-common php5-suhosin php5-fpm php5-cgi php5-sqlite php5-curl ).each do |pkg_name| 
  package pkg_name do
    action :install
    options "--allow-unauthenticated"
  end
end

service "php" do
  action service_action_state
end
