define :npm_package, :args => nil, :libdir => nil do
  include_recipe "nodejs"
  _name = params[:name]
  _args = params[:args] || _name
  execute "install npm package #{_args}" do
    command "npm install #{_args}"
    user "root"
    only_if %(npm ls installed "#{_args}" | grep "Nothing found")
  end
end
