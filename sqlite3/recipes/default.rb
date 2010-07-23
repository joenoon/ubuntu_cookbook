%w(
  libsqlite3-0
  libsqlite3-dev
  sqlite3
).each do |pkg_name|
  package pkg_name do
    action :install
  end
end
