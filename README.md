# ansible nephio

## installation

This repo provides the artifacts to install a Nephio environment using ansible. We assume a VM is created which the following characteristics:

- ubuntu 22.04LTS -> this is tested right now
- 32G RAM, 8 vcpu -> we can change this based on the amount of kind clusters we need
- SSH access with a SSH key is setup + username

The creation of the VM is right now out of scope, but we can see what we can do going forward.

The installation creates kind clusters, github repos and the manifests to get a base environment up an running to experiment with Nephio following [nephio ONE summit 2022 workshop](https://github.com/nephio-project/one-summit-22-workshop)

To start you need to install ansible. Below is an example how to install ansible using a virtual environment.

```python
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install ansible
pip install pygithub
ansible-galaxy collection install community.general
```

clone the repo in a local environment

```bash
git clone https://github.com/henderiw-nephio/nephio-ansible-install
```

Besides ansible we need to provide an inventory file that is used by the ansible playbooks to setup your enviornment.

The ansible.config assumes the inventory file is located in inventory/nephio.yaml within the clone environment

```
cd nephio-ansible-install
mkdir -p inventory
touch nephio.yaml
```

Open an editor of your choice and paste the below in the inventory/nephio.yaml file

```yaml
all:
  vars:
    cloud_user: <username that is used to access the VM>
    github_username: <github username>
    github_token: <github personal access token>
    github_organization: <github organization or username>
    proxy:
      http_proxy: 
      https_proxy:
      no_proxy:
    host_os: "linux"  # use "darwin" for MacOS X, "windows" for Windows
    host_arch: "amd64"  # other possible values: "386","arm64","arm","ppc64le","s390x"
    tmp_directory: "/tmp"
    bin_directory: "/usr/local/bin"
    kubectl_version: "1.25.0"
    kubectl_checksum_binary: "sha512:fac91d79079672954b9ae9f80b9845fbf373e1c4d3663a84cc1538f89bf70cb85faee1bcd01b6263449f4a2995e7117e1c85ed8e5f137732650e8635b4ecee09"
    kind_version: "0.17.0"
    cni_version: "0.8.6"
    kpt_version: "1.0.0-beta.23"
    multus_cni_version: "3.9.2"
    nephio:
      install_dir: nephio-install
      packages_url: https://github.com/nephio-project/nephio-packages.git
    clusters:
      mgmt: [172.88.0.0/16, 10.196.0.0/16, 10.96.0.0/16]
      edge1: [172.88.0.0/16, 10.196.0.0/16, 10.96.0.0/16]
      #edge2: [172.88.0.0/16, 10.196.0.0/16, 10.96.0.0/16]
      #region1: [172.88.0.0/16, 10.196.0.0/16, 10.96.0.0/16]
  children:
    vm:
      hosts:
        <ip address of the VM>:
```

Some customization is required to tailor the installation to your environment. Edit the inventory/nephio.yaml file where you update:

- cloud_user: the username that is created to access the VM using SSH
- github_username: your gihub user name
- github_token: github access token to access github [github personal access token](https://docs.github.com/en/enterprise-server@3.4/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- github_organization: This can be a github organization of your github user dependening one how you create your repo's

## deploy nephio environment

Now that the environment is up an running we can install the Nephio environment

First we create some prerequisites, which installs kubectl, kind, kpt, cni and setup the bash environment

```bash
ansible-playbook install-prereq.yaml
```

After we create the github repo(s) Nephio uses

```bash
ansible-playbook create-repos.yaml
```

Next we deploy the kind clusters and install the nephio components

```bash
ansible-playbook deploy-clusters.yaml
```

Lastly we install the environment manifests we use for the workshop scenario's

```bash
ansible-playbook configure-nephio.yaml
```

## destroy nephio environment

To destroy the nephio environment

```
ansible-playbook destroy-clusters.yaml
```