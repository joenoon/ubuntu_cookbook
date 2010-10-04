include_recipe "git"

%w(
  build-essential
  bison
  openssl
  libreadline6
  libreadline6-dev
  curl
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

cookbook_file "/etc/gemrc" do
  source "gemrc"
  owner "root"
  group "root"
  mode "0755"
end

remote_file "/usr/local/src/rvm-install-system-wide" do
  source "http://bit.ly/rvm-install-system-wide"
  mode "0755"
  action :create_if_missing
end

bash "install rvm" do
  code "/usr/local/src/rvm-install-system-wide"
  creates "/usr/local/bin/rvm"
end

cookbook_file "/etc/profile.d/rvm_profile.sh" do
  source "rvm_profile.sh"
  owner "root"
  group "root"
  mode "0755"
end

=begin

Uninstall:

{
rm -rf /usr/local/src/rvm-install-system-wide
rm -rf /usr/local/bin/rvm
rm -rf /etc/profile.d/rvm_profile.sh
rm -rf /usr/local/rvm
find /usr/local/bin -type l 2>/dev/null | xargs file | grep 'broken symbolic link' | cut -f 1 -d ":" | xargs -n 1 rm
}

=end
