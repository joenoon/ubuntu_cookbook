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

rubies = node[:rvm][:rubies].split(" ")
default_ruby = rubies.first

rubies.each do |ruby|

  bash "rvm install #{ruby}" do
    code "rvm install #{ruby}"
    not_if "test -e /usr/local/rvm/rubies/#{ruby}*"
  end
  
end

bash "rvm #{default_ruby} --default" do
  code "rvm #{default_ruby} --default"
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

=begin

Uninstall:

{
rm -rf /usr/local/src/rvm-install-system-wide
rm -rf /usr/local/bin/rvm
rm -rf /etc/profile.d/rvm_profile.sh
rm -rf /usr/local/rvm
}

=end
