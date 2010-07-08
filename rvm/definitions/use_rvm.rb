define :use_rvm, :user => nil, :ruby => nil do
  opts = params
  u = opts[:user]
  r = opts[:ruby]
  raise unless r && u

  ruby_block "rvm use rbx" do
    block do
      Chef::Mixin::Command.popen4(%Q{su - #{u} -c 'bash -l -c "rvm use #{r} && env"'}) do |p,i,o,e|
        o.each_line do |line|
          env_bits = line.split("=")
          k = env_bits[0].to_s.strip
          v = env_bits[1].to_s.strip
          unless k == "" || k =~ /\s/
            ENV[k] = v
          end
        end
      end
    end
  end
end
