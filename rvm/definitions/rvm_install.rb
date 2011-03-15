define :rvm_install do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm install #{rb}" do
    code "rvm install #{rb}"
    not_if "rvm list strings | grep #{rb}"
  end
  %w( rake bundler rack chef ).each do |g|
    rvm_gem_package g do
      action :install
      ruby_wrapper rb
    end
  end
  rvm_default(node[:rvm][:default] || rb)
end
