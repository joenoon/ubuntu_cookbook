include_recipe "ruby_enterprise"

ree_gem "unicorn" do
  action :install
end

remote_file "#{@node[:ruby_enterprise][:install_path]}/bin/unicorn_rails23" do
  source "unicorn_rails23"
  owner "root"
  group "root"
  mode 0755
end
