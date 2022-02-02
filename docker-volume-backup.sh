#!/bin/sh

# check if docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

# check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

VOLUMES=$(docker volume inspect $(docker volume ls --format "{{ .Name }}" --filter driver=local) \
    | jq -r '.[].Name') 

tar -czf volumes.tar.gz $VOLUMES