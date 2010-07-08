define :rvm_gem, :source => nil, :version => nil do
  gem_package params[:name] do
    gem_binary "gem"
    source params[:source] if params[:source]
    version params[:version] if params[:version]
  end
end
