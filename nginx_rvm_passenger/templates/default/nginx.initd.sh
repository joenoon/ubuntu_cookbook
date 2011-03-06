#! /bin/sh

### BEGIN INIT INFO
# Provides:          nginx
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

BASE="<%= node[:nginx_rvm_passenger][:prefix] %>"
PATH=$BASE/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON="$BASE/sbin/nginx"
DAEMON_OPTS="-c $BASE/conf/nginx.conf"
NAME=nginx
DESC=nginx

test -x $DAEMON || exit 0

set -e

. /lib/lsb/init-functions

test_nginx_config() {
  if nginx -t $DAEMON_OPTS
  then
    return 0
  else
    return $?
  fi
}

case "$1" in
  start)
	echo -n "Starting $DESC: "
        test_nginx_config
	start-stop-daemon --start --quiet --pidfile /var/run/$NAME.pid \
		--exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon --stop --quiet --pidfile /var/run/$NAME.pid \
		--exec $DAEMON || true
	echo "$NAME."
	;;
  restart|force-reload)
	echo -n "Restarting $DESC: "
	start-stop-daemon --stop --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON || true
	sleep 1
        test_nginx_config
	start-stop-daemon --start --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  reload)
        echo -n "Reloading $DESC configuration: "
        test_nginx_config
        start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/$NAME.pid \
            --exec $DAEMON || true
        echo "$NAME."
        ;;
  configtest)
        echo -n "Testing $DESC configuration: "
        if test_nginx_config
        then
          echo "$NAME."
        else
          exit $?
        fi
        ;;
  status)
	status_of_proc -p /var/run/$NAME.pid "$DAEMON" nginx && exit 0 || exit $?
	;;
  *)
	echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest}" >&2
	exit 1
	;;
esac

exit 0
