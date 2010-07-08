%w(
  build-essential
  bison
  openssl
  libreadline6
  libreadline6-dev
  curl
  git-core
  zlib1g
  zlib1g-dev
  libssl-dev
  vim
  libsqlite3-0
  libsqlite3-dev
  sqlite3
  libxml2-dev
  subversion
  autoconf
).each do |pkg_name|
  package pkg_name do
    action :install
  end
end

cookbook_file "/etc/profile.d/rvm_profile.sh" do
  source "rvm_profile.sh"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/etc/rvmrc" do
  source "rvmrc"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/etc/gemrc" do
  source "gemrc"
  owner "root"
  group "root"
  mode "0755"
end

remote_file "/usr/local/src/rvm-install-head" do
  source "http://rvm.beginrescueend.com/releases/rvm-install-head"
  mode "0755"
  action :create_if_missing
end

bash "install rvm" do
  code "/usr/local/src/rvm-install-head"
  creates "/usr/local/rvm"
end

rubies = node[:rvm_as_root][:rubies].split(" ")
default_ruby = rubies.first

rubies.each do |ruby|

  bash "rvm install #{ruby}" do
    code "rvm install #{ruby}"
    not_if "test -e /usr/local/rvm/rubies/#{ruby}*"
  end
  
end

bash "rvm --default #{default_ruby}" do
  code "rvm --default #{default_ruby}"
  not_if "test -e /usr/local/rvm/rubies/default"
end

ruby_block "set full env" do
  block do
    Chef::Mixin::Command.popen4(%Q{bash -l -c "env"}) do |p,i,o,e|
      o.each_line do |line|
        env_bits = line.split("=")
        k = env_bits[0].to_s.strip
        v = env_bits[1].to_s.strip
        unless k == "" || k =~ /\s/
          ENV[k] = v
        end
      end
    end
  end
end
