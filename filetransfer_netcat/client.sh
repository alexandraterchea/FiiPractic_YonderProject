#!/bin/bash

SERVER_IP="192.168.100.10"
PORT=12345
FILE_TO_SEND="file_to_send.txt"

if [ ! -f "$FILE_TO_SEND" ]; then
    echo "File $FILE_TO_SEND does not exist. Please create the file and try again"
    exit 1
fi

echo "Sending file $FILE_TO_SEND to $SERVER_IP:$PORT"
nc $SERVER_IP $PORT < "$FILE_TO_SEND"
echo "File sent successfully"