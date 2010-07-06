%w(
  imagemagick 
  libmagickwand-dev
).each do |pkg_name| 
  package pkg_name do
    action :install
  end
end
