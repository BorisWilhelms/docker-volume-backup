#!/bin/sh
DEST_PATH=${1-.}

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v openssl)" ]; then
  echo 'Error: openssl is not installed.' >&2
  exit 1
fi

restart_containers() {
  docker start $RUNNING_CONTAINERS >> /dev/null  
}

trap restart_containers EXIT

RUNNING_CONTAINERS=$(docker ps --format '{{.Label "start_order"}} {{.ID}}' | sort | cut -d ' ' -f2)
docker stop $RUNNING_CONTAINERS >> /dev/null
 
VOLUMES=$(docker volume inspect $(docker volume ls --format "{{ .Name }}" --filter driver=local) \
    | jq -r '.[].Mountpoint') 

# tar all volumes and encrypt them to a file with the current date in the name
DEST_FILE="$DEST_PATH/docker-volume-backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz"
tar -czPf "$DEST_FILE" $VOLUMES

echo "$DEST_FILE"