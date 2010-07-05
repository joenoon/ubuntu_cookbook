package "memcached"

service_action_state = node[:memcached].service_action_state

service "memcached" do
  supports :start => true, :stop => true, :status => true, :restart => true
  action service_action_state
end
