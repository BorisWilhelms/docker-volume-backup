#!/bin/sh

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ ! -f ~/.config/backup ]; then
    echo "~/.config/backup file not found"
    exit 1
fi

. ~/.config/backup

if [ -z "$IDENTITYFILE" ] || [ -z "$USERNAME" ] || [ -z "$HOST" ]; then
    echo "~/.config/backup file is missing some variables"
    exit 1
fi

BACKUP=$($dir/docker-volume-backup.sh "$BACKUP_PATH")

sftp -oIdentityFile="$IDENTITYFILE" "$USERNAME"@"$HOST" <<EOF 
put $BACKUP
EOF

rm "$BACKUP"
