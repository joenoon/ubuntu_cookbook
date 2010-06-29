include_recipe "ruby_enterprise"

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

%w(
  image_science
  rmagick
).each do |gem_name|
  ree_gem gem_name do
    action :install
  end
end
