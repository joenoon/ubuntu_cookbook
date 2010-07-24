package "tofrodos" do
  action :install
end

bash "symlink standard names" do
  code %Q{
    cd /usr/bin
    ln -s fromdos dos2unix
    ln -s todos unix2dos
  }
  creates "/usr/bin/dos2unix"
end
