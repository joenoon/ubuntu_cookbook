%w(
  sysctl
  system_defaults
  rvm
  base
  java
  memcached
  mongodb
  rabbitmq
  postgresql
  php5
  ssmtp
  prosody
  mysql
  nginx
  image_manip
  deploy
  nfs_client
).each do |r|
  include_recipe r
end
