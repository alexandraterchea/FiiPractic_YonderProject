#!/bin/bash

count=0
while [ $count -lt 2 ]; do
  echo "Hello stranger"
  sleep 2
  ((count++)) #count e mereu zero daca nu as fi crescut valoarea
done

 