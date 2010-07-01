%w(
  sysctl
  system_defaults
  rvm
  base
  java
  nfs_client
  memcached
  rabbitmq
  postgresql
  php5
  ssmtp
  prosody
  mysql
  nginx
  image_manip
).each do |r|
  include_recipe r
end
