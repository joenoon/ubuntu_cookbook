execute "apt-get update"

%w( 
  avahi-daemon 
  avahi-utils
).each do |pkg_name|
  package pkg_name do
    action :remove
  end
end

include_recipe "build-essential"

%w(
  libc6-dev 
  sqlite3 
  git-core
  nano
  wget
  ssl-cert
  curl
  sysv-rc-conf
  libssl-dev
  libxslt1-dev
  libcurl4-openssl-dev
).each do |pkg_name| 
  package pkg_name do
    action :install
  end
end
