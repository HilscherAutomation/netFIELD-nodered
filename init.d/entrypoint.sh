#!/bin/bash +e

#check if container is running in host mode
if [[ -z `grep "docker0" /proc/net/dev` ]]; then
  echo "Container not running in host mode. Sure you configured host network mode? Container stopped."
  exit 143
fi

# check if dbus address is already defined -> then dbus-deamon of host shall be used
if [[ ! -S "/var/run/dbus/system_bus_socket" ]]; then
   # else start a dbus daemon instance in the container
   /etc/init.d/dbus start
   touch dbus_in_container_started
elif  [[ -e dbus_in_container_started ]]; then
   # start a dbus daemon instance in the container
   /etc/init.d/dbus start
fi

pidbt=0

# catch signals as PID 1 in a container
# SIGNAL-handler
term_handler() {

  echo "terminating dbus ..."
  if [[ ! -S "/var/run/dbus/system_bus_socket" ]]; then
    /etc/init.d/dbus stop
  fi

  exit 143; # 128 + 15 -- SIGTERM
}

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

#check if we have a user V1 management running
httpUrl='https://127.0.0.1/getLandingPageStructure'
rep=$(curl -k -s $httpUrl)
if [[ $rep == *'model-name'* ]]; then
  sed -i -e 's+//adminAuth: {+adminAuth: require("./user-authentication_v1.js"),\n    //adminAuth: {+' /usr/lib/node_modules/node-red/settings.js
else
  sed -i -e 's+adminAuth: require("./user-authentication_v1.js"),\n    //adminAuth: {+//adminAuth: {+' /usr/lib/node_modules/node-red/settings.js
fi


#check if we have a user V2 management running
httpUrl='https://127.0.0.1/cockpit/login'
rep=$(curl -k -s $httpUrl -H 'cookie: cockpit=deleted')
if [[ $rep == *'Authentication failed'* ]]; then
  sed -i -e 's+//adminAuth: {+adminAuth: require("./user-authentication_v2.js"),\n    //adminAuth: {+' /usr/lib/node_modules/node-red/settings.js
else
  sed -i -e 's+adminAuth: require("./user-authentication_v2.js"),\n    //adminAuth: {+//adminAuth: {+' /usr/lib/node_modules/node-red/settings.js
fi


# start Node-RED as background task
/usr/bin/node-red flows.json &

# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
