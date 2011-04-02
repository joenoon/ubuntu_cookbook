nodev = '0.4.3'
npmv = '0.3.17'
node_src_tgz = "/usr/local/src/node-v#{nodev}.tar.gz"
npm_src_tgz = "/usr/local/src/npm-v#{npmv}.tar.gz"

execute "install nodejs" do
  user "root"
  cwd "/usr/local/src"
  command [
    "rm -rf node-v#{nodev}",
    "mkdir node-v#{nodev}",
    "cd node-v#{nodev}",
    "tar xzf #{node_src_tgz} --strip-components=1",
    "./configure",
    "make",
    "make install"
  ].join(" && ")
  action :nothing
end

cookbook_file node_src_tgz do
  source "node-v#{nodev}.tar.gz"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:execute => "install nodejs"), :immediately
end

execute "install npm" do
  user "root"
  cwd "/usr/local/src"
  command [
    "rm -rf npm-v#{npmv}",
    "mkdir npm-v#{npmv}",
    "cd npm-v#{npmv}",
    "tar xzf #{npm_src_tgz} --strip-components=1",
    "node cli.js install ."
  ].join(" && ")
  action :nothing
end

cookbook_file npm_src_tgz do
  source "npm-v#{npmv}.tar.gz"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
  notifies :run, resources(:execute => "install npm"), :immediately
end
