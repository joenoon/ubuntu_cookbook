#! /bin/sh

### BEGIN INIT INFO
# Provides:          redis
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the redis server
# Description:       starts redis using start-stop-daemon
### END INIT INFO

BASE=/usr/local/redis
PATH=$BASE/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON="$BASE/redis-server"
DAEMON_OPTS="$BASE/redis.conf"
NAME=redis
DESC=redis

test -x $DAEMON || exit 0

set -e

. /lib/lsb/init-functions

case "$1" in
  start)
	echo -n "Starting $DESC: "
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
  restart)
	echo -n "Restarting $DESC: "
	start-stop-daemon --stop --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON || true
	sleep 1
	start-stop-daemon --start --quiet --pidfile \
		/var/run/$NAME.pid --exec $DAEMON -- $DAEMON_OPTS || true
	echo "$NAME."
	;;
  reload)
        echo -n "Reloading $DESC configuration: "
        start-stop-daemon --stop --signal HUP --quiet --pidfile /var/run/$NAME.pid \
            --exec $DAEMON || true
        echo "$NAME."
        ;;
  status)
	status_of_proc -p /var/run/$NAME.pid "$DAEMON" redis && exit 0 || exit $?
	;;
  *)
	echo "Usage: $NAME {start|stop|restart|reload|status}" >&2
	exit 1
	;;
esac

exit 0
