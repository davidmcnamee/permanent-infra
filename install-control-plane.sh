#!/bin/bash
set -e
JSON_INPUT=`cat`
K3S_IP=$(echo $JSON_INPUT | sed 's/.*"k3s_ip"\: *"\([^ ]*\)".*/\1/')
if [ $JSON_INPUT == $K3S_IP ]; then
  echo "Did not recognize json input" >&2 
  exit 1
fi
function my_ssh() {
  ssh -o "ConnectTimeout 3" \
      -o "StrictHostKeyChecking no" \
      -o "UserKnownHostsFile /dev/null" \
      -o "LogLevel ERROR" \
      -i ~/.ssh/permanent-infra-ec2.pem \
      "ubuntu@$K3S_IP" \
          "$@"
}
my_ssh 'curl -sfL https://get.k3s.io | sh -' > /dev/null
my_ssh 'echo "{\"k3s_token\":\"`sudo cat /var/lib/rancher/k3s/server/node-token`\"}"'
