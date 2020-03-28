#!/bin/bash

CONJUR_AUTHN_API_KEY=$CONJUR_AUTHN_API_KEY
CONJUR_AUTHN_LOGIN=$CONJUR_AUTHN_LOGIN

echo "[INFO] Rename original conjur_variable.py"
sudo mv /usr/lib/python3.6/site-packages/ansible/plugins/lookup/conjur_variable.py /usr/lib/python3.6/site-packages/ansible/plugins/lookup/orig_conjur_variable.py
echo "[INFO] Coping new conjur_variable.py"
sudo cp conjur_variable.py /usr/lib/python3.6/site-packages/ansible/plugins/lookup/conjur_variable.py
echo "[INFO] Retrieving DAP public certificate"
openssl s_client -showcerts -connect dap-master:443 < /dev/null 2> /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > conjur.pem

echo "[INFO] Preparing DAP parameters for ansible"
export CONJUR_APPLIANCE_URL="https://dap-master"
export CONJUR_ACCOUNT="cybr"
export CONJUR_CERT_FILE="conjur.pem"
export ANSIBLE_HOST_KEY_CHECKING="False"
export SSL_CERT_FILE="conjur.pem"
export CONJUR_AUTHN_LOGIN=$CONJUR_AUTHN_LOGIN
export CONJUR_AUTHN_API_KEY=$CONJUR_AUTHN_API_KEY
echo $CONJUR_AUTHN_LOGIN
echo $CONJUR_AUTHN_API_KEY

echo "[INFO] Executing ansible-playbook.."
ansible-playbook -i playbooks/inventory/hosts playbooks/ssh_user_pwd.yml