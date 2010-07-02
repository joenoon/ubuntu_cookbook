package "nfs-common"

node[:nfs_client][:mounts].each do |m|

  directory m[:mount_point] do
    owner "root"
    group "root"
    mode 0700
    action :create
    not_if "test -e #{m[:mount_point]}"
  end

  mount m[:mount_point] do
    device "#{m[:server]}:#{m[:path]}"
    fstype "nfs"
    options "rw,nodev,nosuid,sync,resvport,intr"
    action [:mount, :enable]
  end

end
