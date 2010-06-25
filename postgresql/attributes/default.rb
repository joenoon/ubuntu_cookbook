set_unless[:postgresql][:version] = '8.4'

version = @node[:postgresql][:version]

set_unless[:postgresql][:pg_hba_conf] = "/etc/postgresql/#{version}/main/pg_hba.conf"
set_unless[:postgresql][:postgresql_conf] = "/etc/postgresql/#{version}/main/postgresql.conf"

set_unless[:postgresql][:config][:data_directory] = "/var/lib/postgresql/#{version}/main"
set_unless[:postgresql][:config][:hba_file] = "/etc/postgresql/#{version}/main/pg_hba.conf"
set_unless[:postgresql][:config][:ident_file] = "/etc/postgresql/#{version}/main/pg_ident.conf"
set_unless[:postgresql][:config][:external_pid_file] = "/var/run/postgresql/#{version}-main.pid"
set_unless[:postgresql][:config][:port] = 5432
set_unless[:postgresql][:config][:max_connections] = 100
set_unless[:postgresql][:config][:unix_socket_directory] = '/var/run/postgresql'
set_unless[:postgresql][:config][:ssl] = true
set_unless[:postgresql][:config][:shared_buffers] = '32MB'
set_unless[:postgresql][:config][:log_line_prefix] = '%t '
set_unless[:postgresql][:config][:datestyle] = 'iso, mdy'
set_unless[:postgresql][:config][:lc_messages] = 'en_US.UTF-8'
set_unless[:postgresql][:config][:lc_monetary] = 'en_US.UTF-8'
set_unless[:postgresql][:config][:lc_numeric] = 'en_US.UTF-8'
set_unless[:postgresql][:config][:lc_time] = 'en_US.UTF-8'
set_unless[:postgresql][:config][:default_text_search_config] = 'pg_catalog.english'
set_unless[:postgresql][:config][:listen_addresses] = '127.0.0.1'
