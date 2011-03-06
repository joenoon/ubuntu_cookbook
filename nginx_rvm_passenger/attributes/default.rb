set_unless[:nginx_rvm_passenger][:worker_processes] = node[:cpu][:total]
set_unless[:nginx_rvm_passenger][:worker_connections] = node[:cpu][:total].to_i * 1024
set_unless[:nginx_rvm_passenger][:ruby_wrapper] = "1.9.2"
set_unless[:nginx_rvm_passenger][:passenger_tgz] = "http://rubyforge.org/frs/download.php/74379/passenger-3.0.4.tar.gz"
set_unless[:nginx_rvm_passenger][:prefix] = "/opt/nginx"
