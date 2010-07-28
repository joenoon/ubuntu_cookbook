include_recipe "rvm"

rvm_gem "rails" do
  action :install
  version node[:rails_stable][:version]
end
