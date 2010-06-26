package "smbfs"
package "smbclient"

ruby_block "clean samba shares" do
  block do
    conf = Chef::Util::FileEdit.new("/etc/fstab")
    conf.search_file_delete_line(/\scifs\s/)
    conf.write_file
  end
  action :nothing
end

if @node[:samba][:enabled]
  @node[:samba][:share] = @node[:samba][:share].to_s.gsub(" ", '\\\040')
  template "/etc/samba/user" do
    source "user.erb"
    owner "root"
    group "root"
    mode "0400"
  end
  
  directory @node[:samba][:mount]

  bash "add samba share" do
    code %Q{
      set +e
      umount #{@node[:samba][:mount]}
      set -e
      cat /etc/samba/current_mount >> /etc/fstab
      mount #{@node[:samba][:mount]}
      true
    }
    action :nothing
  end

  template "/etc/samba/current_mount" do
    source "current_mount.erb"
    owner "root"
    group "root"
    mode "0400"
    notifies :run, resources(:bash => "add samba share"), :immediately
    action :nothing
  end

  template "/etc/samba/current_share" do
    source "current_share.erb"
    owner "root"
    group "root"
    mode "0400"
    notifies :create, resources(:ruby_block => "clean samba shares"), :immediately
    notifies :create, resources(:template => "/etc/samba/current_mount"), :immediately
  end
else
  file "/etc/samba/current_share" do
    action :delete
    notifies :create, resources(:ruby_block => "clean samba shares"), :immediately
  end
  file "/etc/samba/user" do
    action :delete
  end
end