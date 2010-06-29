deb_url = node[:ruby_enterprise][:deb_url]
src_deb = "/usr/local/src/#{File.basename(deb_url)}"

remote_file src_deb do
  source deb_url
  action :create_if_missing
end

dpkg_package "ruby enterprise" do
  source src_deb
end
