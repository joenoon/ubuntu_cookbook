define :rvm_install do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm install #{rb}" do
    code %Q{
      rvm install #{rb}
      rvm wrapper #{rb} #{rb}
      /usr/local/rvm/bin/#{rb}_gem install rake bundler
    }
    only_if "rvm use #{rb} | grep not | grep installed"
  end
end
