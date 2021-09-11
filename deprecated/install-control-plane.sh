#!/bin/bash
set -e
JSON_INPUT=`cat`
K3S_IP=$(echo $JSON_INPUT | sed 's/.*"k3s_ip"\: *"\([^ ]*\)".*/\1/')
if [ $JSON_INPUT == $K3S_IP ]; then
  echo "Did not recognize json input" "$JSON_INPUT" >&2 
  exit 1
fi
if ! grep -Fq "$K3S_IP" ~/.ssh/config ; then
  echo -e "\nHost $K3S_IP\n  User ubuntu\n  IdentityFile ~/.ssh/permanent-infra-ec2.pem\n" >> ~/.ssh/config
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
my_ssh "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--tls-san $K3S_IP' sh -" > /dev/null
K3S_TOKEN=$(my_ssh 'sudo cat /var/lib/rancher/k3s/server/node-token')
NEW_KUBECONFIG=$(my_ssh 'sudo cat /etc/rancher/k3s/k3s.yaml')

NEW_KUBECONFIG="${NEW_KUBECONFIG/127.0.0.1/$K3S_IP}"
NEW_KUBECONFIG="${NEW_KUBECONFIG//default/k3s_ec2}"
echo "$NEW_KUBECONFIG" > ~/.kube/new-config
export KUBECONFIG=~/.kube/config:~/.kube/new-config
kubectl config view --flatten > ~/.kube/config
export KUBECONFIG=~/.kube/config

echo "{\"k3s_token\":\"$K3S_TOKEN\"}"
