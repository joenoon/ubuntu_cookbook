define :rvm_install do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm install #{rb}" do
    code %Q{
      rvm install #{rb}
      rvm #{rb} gem install rake bundler rack chef
    }
    not_if "rvm list strings | grep #{rb}"
  end
  rvm_default(node[:rvm][:default] || rb)
end
