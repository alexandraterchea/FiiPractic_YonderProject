#!/bin/bash


PORT=12345
DIR="received_files"

if [ ! -d "$DIR" ]; then
    mkdir "$DIR"
fi

echo "Server is listening on port $PORT"
nc -l $PORT > "$DIR/received_file.txt"

echo "File received and saved to $DIR"