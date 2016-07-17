#! /usr/bin/env bash

cleanup()
# example cleanup function
{
  docker-compose stop
  docker-compose rm -f
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



SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
MSG_HEADER="\e[32;1m[$SCRIPT_NAME]\e[0m"
MSG_ERROR="\e[31;1m[ERROR]\e[0m"

# Check if command "docker" is available
if ! hash docker 2>/dev/null; then
    printf "$MSG_HEADER$MSG_ERROR docker 1.10 or later is required!\n"
    printf "$MSG_HEADER Visit https://docs.docker.com/engine/installation/ for installation guide\n"
    printf "$MSG_HEADER $SCRIPT_NAME is aborted\n"
    exit
fi

# Check if docker-compose exists.
# If not, ask user if download docker-compose1.6.2 if it doesn't exists
if ! hash docker-compose 2>/dev/null; then
    printf "$MSG_HEADER docker-compose 1.6 or later is required\n"
    printf "$MSG_HEADER Would you like to install docker-compose 1.6.2 at /usr/local/bin/docker-compose?\n"
    printf "$MSG_HEADER This operation requires root privileges (Y/N)"
    read -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > .docker-compose.tmp && sudo mv .docker-compose.tmp /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    else
        printf "$MSG_HEADER$MSG_ERROR docker-compose 1.6 or later is required\n"
        printf "$MSG_HEADER To install manually please refer to https://docs.docker.com/compose/install/\n"
        printf "$MSG_HEADER $SCRIPT_NAME is aborted\n"
        exit
    fi
fi

printf "$MSG_HEADER Start running...\n"

# Disable access control for X server
xhost +

# Start the nodes!
if ! docker-compose up -d; then
    printf "$MSG_HEADER$MSG_ERROR $SCRIPT_NAME exited on error\n"
    exit
fi

printf "$MSG_HEADER Hit Ctrl+C to stop..\n"

while true; do read x; done

