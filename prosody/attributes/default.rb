set_unless[:prosody][:admins] = []
set_unless[:prosody][:use_libevent] = false
set_unless[:prosody][:modules_enabled] = %w(
  roster
  saslauth
  tls
  dialback
  disco
  private
  vcard
  legacyauth
  version
  uptime
  time
  ping
  register
)
set_unless[:prosody][:modules_disabled] = []
set_unless[:prosody][:pidfile] = "/var/run/prosody/prosody.pid"
set_unless[:prosody][:allow_registration] = false
set_unless[:prosody][:log] = {
  :error => "/var/log/prosody/prosody.err",
  :info => "/var/log/prosody/prosody.log"
}
set_unless[:prosody][:additional_config] = %q{VirtualHost "localhost"}
set_unless[:prosody][:modules_path] = "/usr/lib/prosody/modules"
set_unless[:prosody][:external_modules] = {}
