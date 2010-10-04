define :rvm_default do
  rb = params[:name]
  include_recipe "rvm"
  bash "rvm #{rb} --default" do
    code "rvm #{rb} --default"
    only_if "rvm use #{rb}"
  end
end
