#!/bin/bash

name=${1:-"stranger"} #aici fara spatii 

if [[ -z "$1" ]]; then
  echo "usage: $0 <name> <role>"
  exit 1
fi

echo "Hello, $name!"
