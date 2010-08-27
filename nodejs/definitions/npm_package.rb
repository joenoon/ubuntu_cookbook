define :npm_package, :args => nil, :libdir => nil do
  include_recipe "nodejs"
  _name = params[:name]
  _args = params[:args] || _name
  _libdir = params[:libdir] || "/usr/local/lib/node"
  execute "install npm package #{_args}" do
    command "npm install #{_args}"
    user "root"
    not_if "test -e #{_libdir}/#{_name}*"
  end
end
