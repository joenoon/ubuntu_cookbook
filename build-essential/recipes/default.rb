%w(
  build-essential
  binutils-doc
  autoconf
  flex
  bison
  debconf-utils
).each do |pkg_name| 
  package pkg_name do
    action :install
  end
end
