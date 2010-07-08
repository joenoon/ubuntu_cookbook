define :install_rvm, :user => nil, :group => nil, :rubies => "ruby-1.8.7", :default => nil, :use => nil do

  opts = params
  _user = opts[:user]
  raise unless _user

  include_recipe "rvm"
  
  user _user do
    shell "/bin/bash"
  end
  
  user_info = Etc.getpwnam(_user)
  home_dir = user_info.dir
  _group = opts[:group] || user_info.gid
  
  directory "#{home_dir}/.gem" do
    recursive true
    owner _user
    group _group
  end
  
  remote_file "#{home_dir}/rvm-install-head" do
    source "http://rvm.beginrescueend.com/releases/rvm-install-head"
    owner _user
    group _group
    mode "0755"
    action :create_if_missing
  end

  bash "#{home_dir}/rvm-install-head" do
    user _user
    group _group
    code "#{home_dir}/rvm-install-head"
    creates "#{home_dir}/.rvm"
  end
  
  rubies = opts[:rubies].split(" ")
  default = opts[:default] || rubies.first
  
  rubies.each do |ruby|

    bash "rvm install #{ruby}" do
      user _user
      group _group
      code <<-CODE
        source /etc/profile
        rvm install #{ruby}
      CODE
      not_if "test -e #{home_dir}/.rvm/rubies/#{ruby}*"
    end
    
  end

  bash "rvm --default #{default}" do
    user _user
    group _group
    code <<-CODE
      source /etc/profile
      rvm --default #{default}
    CODE
    not_if "test -e #{home_dir}/.rvm/rubies/default"
  end
  
  if opts[:use]
    use_rvm do
      user _user
      ruby default
    end
  end
  
end
