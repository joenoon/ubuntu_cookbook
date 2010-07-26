set_unless[:git][:config] = {}
set_unless[:git][:config]["color.ui"] = "auto"
set_unless[:git][:config]["color.diff"] = "auto"
set_unless[:git][:config]["color.status"] = "auto"
set_unless[:git][:config]["color.branch"] = "auto"
set_unless[:git][:config]["alias.co"] = "checkout"
set_unless[:git][:config]["alias.ci"] = "commit"
set_unless[:git][:config]["alias.st"] = "status"
set_unless[:git][:config]["alias.br"] = "branch"
set_unless[:git][:config]["alias.df"] = "diff"
set_unless[:git][:config]["alias.lg"] = "log -p"
set_unless[:git][:config]["alias.lg"] = "log -p"
set_unless[:git][:config]["alias.lol"] = "log --graph --decorate --pretty=oneline --abbrev-commit"
set_unless[:git][:config]["alias.lola"] = "log --graph --decorate --pretty=oneline --abbrev-commit --all"
set_unless[:git][:config]["core.editor"] = "nano"
set_unless[:git][:config]["core.pager"] = "less"
set_unless[:git][:config]["branch.autosetupmerge"] = "true"
set_unless[:git][:config]["core.autocrlf"] = "input"

