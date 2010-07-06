define :unicorn_app, {
  :owner => "unicorn", 
  :group => "unicorn", 
  :add_to_group => nil,
  :base => "/unicorn", 
  :nfs_server => nil, 
  :nfs_path => nil, 
  :rails_env => nil,
  :rvm_spec => nil,
  :preflight => nil,
  :nginx_name => "default",
  :nginx_source => nil
} do
  
  opts = params

  user opts[:owner] do
    shell "/bin/bash"
  end
  
  if opts[:add_to_group]
    group opts[:add_to_group] do
      members [ opts[:owner] ]
      append true
    end
  end
  
  app_path = File.join(opts[:base], opts[:name])
  app_current_path = "#{app_path}/current"

  [ opts[:base], app_path, app_current_path, "#{app_path}/shared", "#{app_path}/shared/pids", "#{app_path}/shared/log", "#{app_path}/shared/sockets" ].each do |path|
    directory path do
      mode "0755"
      owner opts[:owner]
      group opts[:group]
      not_if { File.exist?(path) }
    end
  end

  template "/etc/init.d/#{opts[:name]}" do
    cookbook "deploy"
    source "unicorn.initd.sh"
    owner "root"
    group "root"
    mode "0755"
    backup false
    variables :name => opts[:name], :rails_env => opts[:rails_env], :rvm_spec => opts[:rvm_spec], :owner => opts[:owner], :base => opts[:base]
  end
  
  if opts[:nfs_server] && opts[:nfs_path]
    nfs_mount app_current_path do
      owner opts[:owner]
      group opts[:group]
      server opts[:nfs_server]
      path opts[:nfs_path]
    end
  end
  
  if opts[:preflight]
    bash "preflight for #{opts[:name]}" do
      cwd app_current_path
      code opts[:preflight]
      user opts[:owner]
      group opts[:group]
      action :run
    end
  end

  service opts[:name] do
    supports :restart => true
    action :restart
  end
  
  nginx_site opts[:nginx_name] do
    source opts[:nginx_source]
    variables :root => app_current_path, :base => app_path
  end

end
