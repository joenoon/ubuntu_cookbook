include_recipe "ruby_enterprise::default"

@node[:ruby_enterprise][:install_gems].each do |x|
  p, v, s = x
  ree_gem p do
    source s if s
    version v if v
  end
end
