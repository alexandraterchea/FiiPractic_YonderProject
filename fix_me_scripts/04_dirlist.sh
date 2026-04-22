#!/bin/bash

echo "List directories in /var"

for dir in /var/*; do #nu era complet forul
  echo "$dir: size=$(du -sh $dir 2>/dev/null | cut -f1)"
done
