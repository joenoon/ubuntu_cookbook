package "git-core" do
  action :install
end

node[:git][:config]["color.diff"] ||= "false"
node[:git][:config]["color.status"] ||= "auto"
node[:git][:config]["color.branch"] ||= "auto"
node[:git][:config]["alias.co"] ||= "checkout"
node[:git][:config]["alias.ci"] ||= "commit"
node[:git][:config]["alias.st"] ||= "status"
node[:git][:config]["alias.br"] ||= "branch"
node[:git][:config]["alias.df"] ||= "diff"
node[:git][:config]["alias.lg"] ||= "log -p"
node[:git][:config]["alias.lg"] ||= "log -p"
node[:git][:config]["alias.lol"] ||= "log --graph --decorate --pretty=oneline --abbrev-commit"
node[:git][:config]["alias.lola"] ||= "log --graph --decorate --pretty=oneline --abbrev-commit --all"
node[:git][:config]["core.editor"] ||= "nano"
node[:git][:config]["core.pager"] ||= "less"
node[:git][:config]["branch.autosetupmerge"] ||= "true"
node[:git][:config]["core.autocrlf"] ||= "input"

node[:git][:config].each_pair do |k, v|
  execute %Q{git config --system "#{k}" "#{v}"}
end
