node[:unicorn][:apps].each do |app|

  template "/etc/init.d/#{app[:env][:name]}" do
    source "unicorn.initd.erb"
    owner "root"
    group "root"
    mode "0755"
    backup false
    variables :env => app[:env]
  end

  if app[:preflight]
    bash "preflight for #{app[:env][:name]}" do
      cwd app[:env][:working_directory]
      code app[:preflight]
      action :run
    end
  end

  service app[:env][:name] do
    supports :restart => true, :stop => true, :start => true
    action(app[:service] || [ :stop, :disable ])
  end

end
