arch = node[:kernel][:machine] == "x86_64" ? "x86_64" : "i686"

set_unless[:mongodb][:arch] = arch
set_unless[:mongodb][:version] = "1.4.4"
