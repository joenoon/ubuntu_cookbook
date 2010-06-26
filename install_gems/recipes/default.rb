@node[:install_gems].each do |x|
  p, v, s = x
  gem_package p do
    source s if s
    version v if v
  end
end
