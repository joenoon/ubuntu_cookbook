define :jn_profile, :user => nil do
  _user = params[:user]
  raise unless _user
  
  user _user do
    shell "/bin/bash"
  end
  
  user_info = Etc.getpwnam(_user)
  
  f = File.read("#{user_info.dir}/.profile")
  
  lines = [
    { :match => /function duf/, :content => %Q{function duf {\ndu -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\\t${fname}"; break; fi; size=$((size/1024)); done; done\n}} },
    { :match => /alias gst/, :content => "alias gst='git status'" },
    { :match => /alias gd/, :content => "alias gd='git diff'" },
    { :match => /alias gdc/, :content => "alias gdc='git diff --cached'" },
    { :match => /alias gc/, :content => "alias gc='git commit -v'" },
    { :match => /export EDITOR/, :content => "export EDITOR=nano" }
  ]
  
  File.open("#{user_info.dir}/.profile", "a") do |fo|
    lines.each do |line|
      unless f =~ line[:match]
        fo.puts line[:content]
      end
    end
  end
   
end