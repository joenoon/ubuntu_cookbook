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

cookbook_file "/etc/rvmrc" do
  source "rvmrc"
  owner "root"
  group "root"
  mode "0755"
end

cookbook_file "/etc/profile.d/rvm_profile.sh" do
  source "rvm_profile.sh"
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
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

execute "/usr/local/src/rvm-install-head" do
  creates "/usr/local/rvm"
end

execute "rvm install ree" do
  not_if "test -e /usr/local/rvm/rubies/ree-1.8.7*"
end

execute "rvm install 1.9.2-head" do
  not_if "test -e /usr/local/rvm/rubies/ruby-1.9.2-head"
end

execute "rvm --default ree" do
  not_if "test -e /usr/local/rvm/rubies/default"
end
