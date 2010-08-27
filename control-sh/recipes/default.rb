cookbook_file "#{node[:"control-sh"][:install_dir]}/control-sh" do
  source "control-sh"
  owner "root"
  group "root"
  mode "0755"
end
