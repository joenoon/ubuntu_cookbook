%w(
  imagemagick 
  libmagickwand-dev
  libfreeimage-dev 
  libfreeimage3 
).each do |pkg_name| 
  package pkg_name do
    action :install
  end
end
