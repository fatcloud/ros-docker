#! /usr/bin/env bash

cleanup()
# example cleanup function
{
  $COMPOSE stop
  $COMPOSE rm -f
  xhost -
  return $?
}

control_c()
# run if user hits control-c
{
  printf "\n$MSG_HEADER SIGINT received... now calling the containers to stop...\n"
  cleanup
  printf "$MSG_HEADER $SCRIPT_NAME exited normally.\n"
  exit $?
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT
 


# ============================ Everything start from here ==============================


LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
COMPOSE="$LOCATION/../docker-compose"
SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
MSG_HEADER="\e[32;1m[$SCRIPT_NAME]\e[0m"
MSG_ERROR="\e[31;1m[ERROR]\e[0m"

# Check if command "docker" is available
if ! hash docker 2>/dev/null; then
    printf "$MSG_HEADER$MSG_ERROR docker installation is required to run this script!\n"
    printf "$MSG_HEADER Visit https://docs.docker.com/engine/installation/ for installation guide"
    exit
fi

# Download docker-compose1.5.0rc if it doesn't exists
if [ ! -f $COMPOSE ]; then
    printf "$MSG_HEADER Running for the first time, initialing... \n"
    curl -L https://github.com/docker/compose/releases/download/1.5.0rc1/docker-compose-`uname -s`-`uname -m` > $COMPOSE
    chmod +x $COMPOSE
fi

printf "$MSG_HEADER Start running...\n"

# Disable access control for X server
xhost +

# Start the nodes!
cd $LOCATION
if ! $COMPOSE --x-networking up -d; then
    printf "$MSG_HEADER$MSG_ERROR $SCRIPT_NAME exited on error\n"
    exit
fi

printf "$MSG_HEADER Hit Ctrl+C to stop..\n"

while true; do read x; done

