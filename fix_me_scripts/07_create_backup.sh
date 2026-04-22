#!/bin/bash

SOURCE=$1
DEST=/tmp/backups

mkdir -p $DEST

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME=$(basename $SOURCE)_$TIMESTAMP.bak

echo "Backing up: $SOURCE"
cp $SOURCE $DEST/$BACKUP_NAME

echo -e "Saved to: $DEST/$BACKUP_NAME \n"
