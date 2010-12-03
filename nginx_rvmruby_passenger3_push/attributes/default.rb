set[:nginx_rvmruby_passenger3_push][:worker_processes] = node[:cpu][:total]
set[:nginx_rvmruby_passenger3_push][:worker_connections] = node[:cpu][:total].to_i * 1024
set[:nginx_rvmruby_passenger3_push][:ruby_wrapper] = "1.8.7"
set[:nginx_rvmruby_passenger3_push][:passenger_tgz] = "http://rubyforge.org/frs/download.php/72923/passenger-3.0.0.tar.gz"
set[:nginx_rvmruby_passenger3_push][:passenger_extracts_to] = "passenger-3.0.0"
set[:nginx_rvmruby_passenger3_push][:push_tgz] = "https://github.com/slact/nginx_http_push_module/tarball/d17ac72a188d2d9893808e7267ef036c5e5b2662"
set[:nginx_rvmruby_passenger3_push][:push_extracts_to] = "slact-nginx_http_push_module-d17ac72"
