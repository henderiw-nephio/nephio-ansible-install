MY_ZONE =? us-west1-b
MY_PROJECT_ID =? srlinux
MY_CLOUD_USERNAME =? henderiw

SHELL := /usr/bin/env bash

all:

.PHONY: packer-build
packer-build: ## build packer file
	export MY_ZONE="$(MY_ZONE)"; export MY_PROJECT_ID="$(MY_PROJECT_ID)"; export MY_CLOUD_USERNAME="$(MY_CLOUD_USERNAME)"
	cd packer/gce; packer build -force -var-file="ubuntu-2204.json" packer.json; cd ../.. 

