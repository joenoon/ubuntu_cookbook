define :rvm_install do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm install #{rb}" do
    code %Q{
      rvm install #{rb}
      rvm #{rb} gem install rake bundler rack
    }
    only_if "rvm use #{rb} | grep not | grep installed"
  end
end
