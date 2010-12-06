config = {
  :worker_processes                                => node[:cpu][:total],
  :worker_connections                              => node[:cpu][:total].to_i * 1024,
  :git_repo                                        => "https://github.com/wandenberg/nginx-push-stream-module.git",
  :git_tag                                         => "master",
  :nginx_version                                   => "0.7.67",
  :clone_to                                        => "/usr/local/src/nginx_stream",
  :install_prefix                                  => "/opt/nginx_stream",
  :basename                                        => "nginx_stream",
  :configure_options                               => "--with-http_ssl_module --with-http_stub_status_module --add-module=nginx-push-stream-module",
  :server_name                                     => "_",
  :port                                            => 80,
  
  # ssl options

    # set up an ssl server as well?
    :ssl                                             => false,
    
    :ssl_port                                        => 443,
    :ssl_certificate                                 => "/etc/ssl/certs/ssl-cert-snakeoil.pem",
    :ssl_certificate_key                             => "/etc/ssl/private/ssl-cert-snakeoil.key",
    :ssl_session_timeout                             => "5m",
    :ssl_protocols                                   => "SSLv2 SSLv3 TLSv1",
    :ssl_ciphers                                     => "ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP",
    :ssl_prefer_server_ciphers                       => "on",
  
  # global settings
  
    :global_tcp_nopush                               => "on",
    :global_tcp_nodelay                              => "on",
    :global_keepalive_timeout                        => "10",
    :global_send_timeout                             => "10",
    :global_client_body_timeout                      => "10",
    :global_client_header_timeout                    => "10",
    :global_sendfile                                 => "on",
    :global_client_header_buffer_size                => "1k",
    :global_large_client_header_buffers              => "2 4k",
    :global_client_max_body_size                     => "1k",
    :global_client_body_buffer_size                  => "1k",
    :global_ignore_invalid_headers                   => "on",
    :global_client_body_in_single_buffer             => "on",
  
  # publisher settings

    # path for publisher
    :publisher_location                              => "/publisher",
    # which argument out of the URL is the channel id... /publisher?channel=XYZ
    :push_stream_channel_id                          => "$arg_channel",
    # message template
    :push_stream_message_template                    => "<script>p(~id~,'~channel~','~text~');</script>",
    # max messages to store in memory
    :push_stream_max_message_buffer_length           => 20,
    # message ttl
    :push_stream_min_message_buffer_timeout          => "5m",
    # client_max_body_size MUST be equal to client_body_buffer_size or you will be sorry.
    :client_max_body_size                            => "32k",
    :client_body_buffer_size                         => "32k",
  
  # subscriber settings
  
    # path for subscriber
    :subscriber_location                             => "/subscriber",
    # which argument out of the URL is the channel id... /subscriber?channel=XYZ
    :push_stream_channels_path                       => "$arg_channel",
    # header to be sent when receiving new subscriber connection
    :push_stream_header_template                     => %Q{<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta http-equiv="Cache-Control" content="no-store"><meta http-equiv="Cache-Control" content="no-cache"><meta http-equiv="Pragma" content="no-cache"><meta http-equiv="Expires" content="Thu, 1 Jan 1970 00:00:00 GMT"><script type="text/javascript">window.onError = null;document.domain = 'localhost';parent.PushStream.register(this);</script></head><body onload="try { parent.PushStream.reset(this) } catch (e) {}">},
    # message template
    :push_stream_message_template                    => "<script>p(~id~,'~channel~','~text~');</script>",
    # content-type
    :push_stream_content_type                        => "text/html; charset=utf-8",
    # subscriber may create channels on demand or only authorized (publisher) may do it?
    :push_stream_authorized_channels_only            => "off",
    # ping frequency
    :push_stream_ping_message_interval               => "10s",
    # disconnection candidates test frequency
    :push_stream_subscriber_disconnect_interval      => "30s",
    # connection ttl to enable recycle
    :push_stream_subscriber_connection_timeout       => "15m",
    # solving some leakage problem with persitent connections in Nginx's chunked filter (ngx_http_chunked_filter_module.c)
    :chunked_transfer_encoding                       => "off"
}
config.each_pair do |key, val|
  set[:nginx_stream][key] = val
end
