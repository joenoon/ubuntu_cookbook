define :nginx_site, :source => nil, :variables => {} do
  include_recipe "nginx"
  opts = params
  template "/etc/nginx/sites-available/#{opts[:name]}" do
    source opts[:source]
    owner "root"
    group "root"
    mode "0644"
    variables opts[:variables]
    backup false
  end

  link "/etc/nginx/sites-enabled/#{opts[:name]}" do
    to "/etc/nginx/sites-available/#{opts[:name]}"
    action :create
  end

  service "nginx" do
    action :reload
  end
end
