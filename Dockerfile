FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss@sha256:eae70293915c10aae4909c407eaa0a59a813bbab9a21667fdbf0e72502b28c3e

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3=3.9.2-3 python3-docker=4.1.0-1.2 tree && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://open-vsx.org/api/redhat/vscode-yaml/1.10.1/file/redhat.vscode-yaml-1.10.1.vsix && \
unzip redhat.vscode-yaml-1.10.1.vsix "extension/*" && \
mv extension /opt/code-oss/extensions/redhat.vscode-yaml

RUN wget -q https://open-vsx.org/api/ms-kubernetes-tools/vscode-kubernetes-tools/1.3.11/file/ms-kubernetes-tools.vscode-kubernetes-tools-1.3.11.vsix && \
unzip ms-kubernetes-tools.vscode-kubernetes-tools-1.3.11.vsix "extension/*" && \
mv extension /opt/code-oss/extensions/ms.kubernetes-tools

RUN mkdir -p /tmp
RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x kubectl && mv kubectl /usr/local/bin/kubectl
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64 && \
chmod +x ./kind && mv kind /usr/local/bin/kind
RUN curl -Lo ./kpt https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.24/kpt_linux_amd64 && \
chmod +x ./kpt && mv kpt /usr/local/bin/kpt
RUN bash -c "$(curl -sL https://get.containerlab.dev)"


RUN mkdir -p /tmp/cni
RUN curl -Lo /tmp/cni/cni-plugins-linux-amd64-v0.8.6.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz && \
cd /tmp/cni && tar -zxvf cni-plugins-linux-amd64-v0.8.6.tgz && rm cni-plugins-linux-amd64-v0.8.6.tgz && cd .

RUN mkdir -p /tmp/nephio-install
RUN kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-system /tmp/nephio-install/nephio-system && \
kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-configsync /tmp/nephio-install/nephio-configsync && \
kpt pkg get --for-deployment https://github.com/nephio-project/nephio-packages.git/nephio-webui /tmp/nephio-install/nephio-webui

RUN mkdir -p /nephio-installation/inventory
COPY ansible.cfg /nephio-installation/
COPY playbooks /nephio-installation/playbooks
COPY roles /nephio-installation/roles
COPY inventory/nephio.yaml /nephio-installation/inventory/
COPY nind/150_install-nephio.sh /etc/workstation-startup.d/
