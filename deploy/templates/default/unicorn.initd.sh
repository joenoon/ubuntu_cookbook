#!/bin/bash
### BEGIN INIT INFO
# Provides:          APPLICATION
# Required-Start:    $all
# Required-Stop:     $network $local_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the APPLICATION unicorns at boot
# Description:       Enable APPLICATION at boot time.
### END INIT INFO
# 
# Use this as a basis for your own Unicorn init script.
# Change APPLICATION to match your app.
# Make sure that all paths are correct.

set -u
set -e

# Change these to match your app:
BASE="<%= @base %>"
APP_NAME="<%= @name %>"
APP_USER="<%= @owner %>"
RAILS_ENV="<%= @rails_env %>"
RVM_SPEC="<%= @rvm_spec %>"
APP_ROOT="$BASE/$APP_NAME/current"
PID="$BASE/$APP_NAME/shared/pids/unicorn.pid"

CMD="cd $APP_ROOT; rvm use $RVM_SPEC; unicorn_rails -D -E $RAILS_ENV -c config/unicorn.rb"

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

rmpid () {
	test -s "$PID" && rm -f $PID
}

sig () {
	test -s "$PID" && kill -$1 `cat $PID` && return 0
	rmpid && return 1
}

oldsig () {
	test -s $old_pid && kill -$1 `cat $old_pid` && return 0
	rmpid && return 1
}

case ${1-help} in
start)
	sig 0 && echo >&2 "Already running" && exit 0
	su - $APP_USER -c "$CMD"
	;;
stop)
	sig QUIT && exit 0
	echo >&2 "Not running"
	;;
force-stop)
	sig TERM && exit 0
	echo >&2 "Not running"
	;;
reload)
	sig HUP && echo reloaded OK && exit 0
	echo >&2 "Couldn't reload, starting '$CMD' instead"
	su - $APP_USER -c "$CMD"
	;;
restart)
	sig USR2 && exit 0
	echo >&2 "Couldn't upgrade, starting '$CMD' instead"
	su - $APP_USER -c "$CMD"
	;;
rotate)
	sig USR1 && echo rotated logs OK && exit 0
	echo >&2 "Couldn't rotate logs" && exit 1
	;;
*)
 	echo >&2 "Usage: $0 <start|stop|restart|upgrade|rotate|force-stop>"
 	exit 1
 	;;
esac
