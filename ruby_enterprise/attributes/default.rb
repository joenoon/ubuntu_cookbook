set_unless[:ruby_enterprise][:install_path] = "/usr/local"
set_unless[:ruby_enterprise][:ruby_bin]     = "#{ruby_enterprise[:install_path]}/bin/ruby"
set_unless[:ruby_enterprise][:gem_bin]     = "#{ruby_enterprise[:install_path]}/bin/gem"
set_unless[:ruby_enterprise][:gems_dir]     = "#{ruby_enterprise[:install_path]}/lib/ruby/gems/1.8/gems"
set_unless[:ruby_enterprise][:deb_url] = if node[:kernel][:machine] == "x86_64"
  "http://rubyforge.org/frs/download.php/71098/ruby-enterprise_1.8.7-2010.02_amd64_ubuntu10.04.deb"
else
  "http://rubyforge.org/frs/download.php/71100/ruby-enterprise_1.8.7-2010.02_i386_ubuntu10.04.deb"
end
set_unless[:ruby_enterprise][:install_gems] = []
