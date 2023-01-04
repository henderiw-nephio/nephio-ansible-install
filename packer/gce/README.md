export MY_ZONE=us-west1-b
export MY_PROJECT_ID="srlinux"
export MY_CLOUD_USERNAME="henderiw"


packer build -var-file="ubuntu-2204.json" packer.json
packer build -force -var-file="ubuntu-2204.json" packer.json 
