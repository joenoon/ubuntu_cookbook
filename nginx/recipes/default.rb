package "nginx"

cookbook_file "/etc/nginx/php5_backend" do
  source "php5_backend"
  owner "root"
  group "root"
  backup false
  mode "0644"
end

unused_sites = Dir.glob("/etc/nginx/sites-enabled/*").map {|x| File.basename(x) } - node[:nginx][:sites].keys.map {|x| x.to_s } - [ "default" ]

node[:nginx][:sites].each_pair do |site, config_content|
  file "/etc/nginx/sites-enabled/#{site}" do
    content config_content
    owner "root"
    group "root"
    mode "0644"
    backup false
  end
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
  action(node[:nginx][:sites].size > 0 ? :delete : :create)
end

unused_sites.each do |unused_site|
  file "/etc/nginx/sites-enabled/#{unused_site}" do
    action :delete
  end
end

service "nginx" do
  supports :start => true, :stop => true, :restart => true, :reload => true
  action node[:nginx][:service]
  if node[:nginx][:service].include?("enable")
    subscribes :reload, resources(:link => "/etc/nginx/sites-enabled/default"), :delayed
    node[:nginx][:sites].keys.each do |site|
      subscribes :reload, resources(:file => "/etc/nginx/sites-enabled/#{site}"), :delayed
    end
  end
end
