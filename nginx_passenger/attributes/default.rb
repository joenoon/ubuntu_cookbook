set[:nginx_passenger][:worker_processes] = node[:cpu][:total]
set[:nginx_passenger][:worker_connections] = node[:cpu][:total].to_i * 1024
