PROJECT    = jenkins

SUBNET_ID  = subnet-dc3d7887
AWS_REGION = ap-northeast-1
VPC_ID     = vpc-e4054783
KEY_NAME   = AWS-VPC-019

envs:
	$(eval VERSION = $(shell date '+%Y%m%d%H%M'))

clean:
	rm -rf packer/manifest.json

build: clean envs
	cd packer/ && packer build \
	  -var 'subnet_id=$(SUBNET_ID)' \
	  -var 'ami_name=$(PROJECT)_$(VERSION)' \
	packer.json

manifest:
	$(eval AWS_AMI = $(shell cat packer/manifest.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))

init:
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform init

terra: manifest
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform apply \
	  -var 'vpc_id=$(VPC_ID)' \
		-var 'subnet_id=$(SUBNET_ID)' \
		-var 'ami=$(AWS_AMI)' \
		-var 'key_name=$(KEY_NAME)'
