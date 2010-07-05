define :nfs_mount, :owner => "root", :group => "root", :server => nil, :path => nil, :options => "rw,nodev,nosuid,sync,resvport,intr" do
  
  opts = params
  
  include_recipe "nfs_client"

  directory opts[:name] do
    owner opts[:owner]
    group opts[:group]
    mode "0700"
    action :create
    not_if "test -e #{opts[:name]}"
  end

  mount opts[:name] do
    device "#{opts[:server]}:#{opts[:path]}"
    fstype "nfs"
    options opts[:options]
    action [:mount, :enable]
  end

end
