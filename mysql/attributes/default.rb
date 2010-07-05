set_unless[:mysql][:server_debian_password] = "root"
set_unless[:mysql][:server_root_password] = "root"
set_unless[:mysql][:server_repl_password] = "root"
set_unless[:mysql][:bind_address]         = "127.0.0.1"
set_unless[:mysql][:datadir]              = "/var/lib/mysql"

# Tunables
set_unless[:mysql][:tunable][:key_buffer]          = "250M"
set_unless[:mysql][:tunable][:max_connections]     = "800"
set_unless[:mysql][:tunable][:wait_timeout]        = "180"
set_unless[:mysql][:tunable][:net_read_timeout]    = "30"
set_unless[:mysql][:tunable][:net_write_timeout]   = "30"
set_unless[:mysql][:tunable][:back_log]            = "128"
set_unless[:mysql][:tunable][:table_cache]         = "128"
set_unless[:mysql][:tunable][:max_heap_table_size] = "32M"

set_unless[:mysql][:enabled] = false
