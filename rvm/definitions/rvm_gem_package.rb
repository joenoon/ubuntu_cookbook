# uses the gem wrapper from rvm
define :rvm_gem_package, :source => nil, :version => nil do
  opts = params
  include_recipe "rvm"
  gem_package opts[:name] do
    source opts[:source] if opts[:source]
    version opts[:version] if opts[:version]
    gem_binary "/usr/local/bin/gem"
  end
end
