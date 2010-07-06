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
  imagemagick
  freeimage
  deploy
  nfs_client
).each do |r|
  include_recipe r
end
