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

cookbook_file "/etc/gemrc" do
  source "gemrc"
  owner "root"
  group "root"
  mode "0755"
end
