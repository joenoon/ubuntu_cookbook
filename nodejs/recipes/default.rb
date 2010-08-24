dl_node_dir = "node-v#{node[:nodejs][:version]}"
tgz_node = "#{dl_node_dir}.tar.gz"
usr_src_file = "/usr/local/src/#{tgz_node}"
url_node = "http://nodejs.org/dist/#{tgz_node}"

execute "install nodejs" do
  user "root"
  cwd "/usr/local/src"
  command [
    "rm -rf #{dl_node_dir}",
    "tar zxf #{tgz_node}",
    "cd #{dl_node_dir}",
    "./configure",
    "make",
    "make install"
  ].join(" && ")
  action :nothing
end

remote_file usr_src_file do
  source url_node
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:execute => "install nodejs"), :immediately
end

execute "install npm" do
  user "root"
  cwd "/usr/local/src"
  command "./npm-install.sh"
  action :nothing
end

remote_file "/usr/local/src/npm-install.sh" do
  source "http://npmjs.org/install.sh"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:execute => "install npm"), :immediately
end
