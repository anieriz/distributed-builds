PROJECT    = jenkins

AWS_SUBNET         = subnet-dc3d7887
AWS_REGION         = ap-northeast-1
VPC_ID             = vpc-e4054783
AWS_SECURITYGROUPS = sg-d9a7f8a1
KEY_NAME           = AWS-VPC-019
AWS_DESIRE         = 2
WORKERS_TYPE       = t2.small

version:
	$(eval VERSION = $(shell date '+%Y%m%d%H%M'))

config:
	$(eval WORKERS_AMI = $(shell cat packer/workers.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))
	$(eval AWS_PEM = $(shell cat key.pem))
	cp -R ansible/roles/jenkins/files/source.ec2.groovy ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|WORKERS_AMI|$(WORKERS_AMI)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|WORKERS_TYPE|$(WORKERS_TYPE)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|AWS_DESIRE|$(AWS_DESIRE)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|AWS_SECURITYGROUPS|$(AWS_SECURITYGROUPS)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|AWS_SUBNET|$(AWS_SUBNET)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|AWS_REGION|$(AWS_REGION)|g' ansible/roles/jenkins/files/ec2.groovy
	sed -i 's|AWS_PEM|$(AWS_PEM)|g' ansible/roles/jenkins/files/ec2.groovy

build-master: version config
	rm -rf packer/master.json
	cd packer/ && packer build \
	  -var 'mode=master' \
	  -var 'subnet_id=$(AWS_SUBNET)' \
	  -var 'ami_name=$(PROJECT)_master_$(VERSION)' \
	packer.json

build-workers: version
	rm -rf packer/workers.json
	cd packer/ && packer build \
	  -var 'mode=workers' \
	  -var 'subnet_id=$(SUBNET_ID)' \
	  -var 'ami_name=$(PROJECT)_workers_$(VERSION)' \
	packer.json

build-all:
	@make build-master
	@make build-workers

init:
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform init

terra: manifest
	$(eval MASTER_AMI = $(shell cat packer/master.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform apply \
	  -var 'vpc_id=$(VPC_ID)' \
		-var 'subnet_id=$(SUBNET_ID)' \
		-var 'ami=$(MASTER_AMI)' \
		-var 'key_name=$(KEY_NAME)'
	@make clear

clear:
	rm -rf packer/master.json
	rm -rf packer/workers.json