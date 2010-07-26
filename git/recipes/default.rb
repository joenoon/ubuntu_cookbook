package "git-core" do
  action :install
end

file "/etc/gitconfig" do
  action :delete
end

node[:git][:config].each_pair do |k, v|
  if v # allow passing false to avoid a default
    execute %Q{git config --system "#{k}" "#{v}"}
  end
end
