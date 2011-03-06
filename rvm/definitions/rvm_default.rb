define :rvm_default do
  rb = params[:name]
  rvm_install rb
  bash "rvm #{rb} --default" do
    code "rvm #{rb} --default"
    only_if "rvm list strings | grep #{rb}"
  end
end
