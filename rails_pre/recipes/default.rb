include_recipe "rvm"

bash "install rails pre" do
  code "gem install rails --pre && gem install sqlite3-ruby && touch /usr/local/src/rails_pre_installed"
  not_if "test -e /usr/local/src/rails_pre_installed"
end
