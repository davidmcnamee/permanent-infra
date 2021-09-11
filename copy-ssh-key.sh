#!/bin/bash
JSON_INPUT=`cat`
IP=$(echo $JSON_INPUT | sed 's/.*"ip"\: *"\([^ ]*\)".*/\1/')
python3 ./update-ssh-config.py $IP
max_tries=40
status_code=1
while [[ $status_code == 1 && $max_tries > 0 ]]; do
    max_tries=$((max_tries-1))
    scp -o StrictHostKeyChecking=accept-new ~/.ssh/id_rsa davidmcnamee@$IP:~/.ssh/id_rsa &> /dev/null
    status_code=$?
    sleep 5
done
if [[ $status_code == 1 ]]; then exit 1; fi
echo "{}"
