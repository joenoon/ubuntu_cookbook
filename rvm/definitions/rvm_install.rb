define :rvm_install do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm install #{rb}" do
    code %Q{
      rvm install #{rb}
      rvm #{rb} gem install rake bundler
    }
    not_if "rvm use #{rb}"
  end
end
