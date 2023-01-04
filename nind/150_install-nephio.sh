#!/bin/bash
# shellcheck disable=SC1091
export USER=user
BASE=$(pwd)
export BASE
export LC_ALL=C.UTF-8
echo "-----------------"
echo "Setting up bash environment"
echo 'alias k=kubectl' | tee -a /home/user/.bashrc > /dev/null
echo 'source <(kubectl completion bash)' | tee -a /home/user/.bashrc > /dev/null
echo 'source <(kpt completion bash)' | tee -a /home/user/.bashrc > /dev/null
echo 'source <(clab completion bash)' | tee -a /home/user/.bashrc > /dev/null 
echo 'source <(kind completion bash)' | tee -a /home/user/.bashrc > /dev/null 
chown -R user:user /tmp/nephio-install
chown -R user:user /tmp/cni
echo "-----------------"
echo "-----------------"
echo "Setting up python"
cd /home/user || exit
python3 -m venv .venv
source .venv/bin/activate
pip3 install --upgrade pip
pip3 install ansible
pip3 install kubernetes
pip3 install pygithub
pip3 install requests
ansible-galaxy collection install community.general
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.docker # required for gitea
echo "-----------------"
echo "Change to install directory"
cd /nephio-installation || exit
echo "-----------------"

echo "-----------------"
cd "$BASE" || exit
echo "nephio-in-docker installation done"
echo "-----------------"