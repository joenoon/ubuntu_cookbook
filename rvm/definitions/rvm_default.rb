define :rvm_default do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm #{rb} --default" do
    code "rvm #{rb} --default"
    not_if "rvm use #{rb} | grep not | grep installed"
  end
end
