#!/bin/bash
JSON_INPUT=`cat`
IP=$(echo $JSON_INPUT | sed 's/.*"ip"\: *"\([^ ]*\)".*/\1/')
python3 ./update-ssh-config.py $IP
sleep 60 # ssh not available immediately after server provision
scp -o StrictHostKeyChecking=accept-new ~/.ssh/id_rsa davidmcnamee@$IP:~/.ssh/id_rsa &> /dev/null
echo "{}"
