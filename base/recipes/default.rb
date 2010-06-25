%w( 
  avahi-daemon 
  avahi-utils
).each do |pkg_name|
  package pkg_name do
    action :remove
  end
end

%w(
  build-essential
  binutils-doc
  autoconf
  flex
  bison
  debconf-utils
  ruby1.8
  ruby1.8-dev
  rdoc1.8
  ri1.8
  irb1.8
  libruby1.8
  libshadow-ruby1.8
  libopenssl-ruby1.8
  libreadline-ruby1.8
  libc6-dev 
  sqlite3 
  geoip-bin 
  libgeoip-dev 
  git-core
  imagemagick 
  libmagickwand-dev
  libfreeimage-dev 
  libfreeimage3 
  nano
  wget
  ssl-cert
  curl
  sysv-rc-conf
  libssl-dev
  libyaml-ruby
  libzlib-ruby
  libxslt1-dev
  libcurl4-openssl-dev
  openjdk-6-jre-headless
  unison
).each do |pkg_name| 
  package pkg_name do
    action :install
  end
end
