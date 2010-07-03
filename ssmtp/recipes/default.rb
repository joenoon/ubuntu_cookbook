package "ssmtp"

template "/etc/ssmtp/revaliases" do
  source "adhoc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :content => node[:ssmtp][:revaliases]
end

template "/etc/ssmtp/ssmtp.conf" do
  source "adhoc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :content => node[:ssmtp][:conf]
end
