package "dovecot-postfix"

service "postfix" do
  action [ :enable, :start ]
end

service "dovecot" do
  action [ :enable, :start ]
end
