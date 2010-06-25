set_unless[:ssmtp][:revaliases] = <<-LINES.gsub(/^ {2}/, '')
  # sSMTP aliases
  # Format:	local_account:outgoing_address:mailhub
  # Example: root:your_login@your.domain:mailhub.your.domain[:port]
  # where [:port] is an optional port number that defaults to 25.
LINES

set_unless[:ssmtp][:conf] = <<-LINES.gsub(/^ {2}/, '')
  # The person who gets all mail for userids < 1000
  # Make this empty to disable rewriting.
  root=postmaster

  # The place where the mail goes. The actual machine name is required no 
  # MX records are consulted. Commonly mailhosts are named mail.domain.com
  # Example for SMTP port number 2525
  # mailhub=mail.your.domain:2525
  # Example for SMTP port number 25 (Standard/RFC)
  # mailhub=mail.your.domain        
  # Example for SSL encrypted connection
  # mailhub=mail.your.domain:465
  mailhub=mail

  # Where will the mail seem to come from?
  rewriteDomain=

  # The full hostname
  hostname=vagrantbase.local

  # Are users allowed to set their own From: address?
  # YES - Allow the user to specify their own From: address
  # NO - Use the system generated From: address
  FromLineOverride=YES

  # Use SSL/TLS to send secure messages to server.
  #UseTLS=YES

  # Use SSL/TLS certificate to authenticate against smtp host.
  #UseTLSCert=YES

  #UseSTARTTLS=YES

  # Use this RSA certificate.
  #TLSCert=/etc/ssl/certs/ssmtp.pem

  # Get enhanced (*really* enhanced) debugging information in the logs
  # If you want to have debugging of the config file parsing, move this option
  # to the top of the config file and uncomment
  #Debug=YES

  AuthUser=someone@vagrantbase.local
  AuthPass=password
  AuthMethod=DIGEST-MD5
LINES
