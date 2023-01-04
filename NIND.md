ssh -L7007:localhost:7007 -L3000:localhost:3000 -L8080:localhost:8080 35.205.223.24

docker build -t nind .

docker run --name=nind --rm --env='DOCKER_OPTS=' --volume=/var/lib/docker --privileged   --cgroup-parent=nephio.slice --restart=no -d -p 8080:80 -p 7007:7007 -p 3000:3000 nind

docker exec -ti nind bash

su - user
source .venv/bin/activate
cd /nephio-installation/
ansible-playbook playbooks/create-gitea.yaml
ansible-playbook playbooks/create-gitea-repos.yaml
ansible-playbook playbooks/deploy-clusters.yaml
ansible-playbook playbooks/configure-nephio.yaml


kubectl --kubeconfig ~/.kube/mgmt-config get pods -A
kubectl --kubeconfig ~/.kube/mgmt-config get packagerevisionresources.porch.kpt.dev
kubectl --kubeconfig ~/.kube/mgmt-config get packagerevisionresources.porch.kpt.dev edge1-3ba1e7b5884f336dfffeac92ba175e94d8031e2c -o yaml