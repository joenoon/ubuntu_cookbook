# uses the gem wrapper from rvm
define :rvm_gem_package, :ruby_wrapper => nil, :source => nil, :version => nil do
  opts = params
  rb = opts[:ruby_wrapper]
  gem_package opts[:name] do
    source opts[:source] if opts[:source]
    version opts[:version] if opts[:version]
    gem_binary "rvm #{rb} gem"
    options "--no-ri --no-rdoc"
  end
end
