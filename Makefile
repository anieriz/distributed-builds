date:
	$(eval DATE = $(shell date '+%Y%m%d%H%M'))
	echo "$(DATE)" > version.txt

security:
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/security && terraform init
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/security && terraform apply \
	  -var 'vpc_id=$(VPC_ID)' \
	-auto-approve

config:
	$(eval WORKERS_AMI = $(shell cat packer/workers.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))
	$(eval AWS_SG = $(shell cd terraform/security && terraform output name))
	rm -rf ansible/roles/master/files/ec2.groovy
	cp -R ansible/roles/master/files/cloud.groovy ansible/roles/master/files/ec2.groovy
	sed -i 's|WORKERS_AMI|$(WORKERS_AMI)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|WORKERS_TYPE|$(WORKERS_TYPE)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|DESIRE_WORKERS|$(DESIRE_WORKERS)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|AWS_SG|$(AWS_SG)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|AWS_SUBNET|$(AWS_SUBNET)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|AWS_REGION|$(AWS_REGION)|g' ansible/roles/master/files/ec2.groovy
	sed -i 's|AWS_AZ|$(AWS_AZ)|g' ansible/roles/master/files/ec2.groovy

build-master: config
	$(eval VERSION = $(shell cat version.txt))
	rm -rf packer/master.json
	cd packer/ && packer build \
	  -var 'mode=master' \
	  -var 'region=$(AWS_REGION)' \
	  -var 'subnet_id=$(AWS_SUBNET)' \
	  -var 'source_ami=$(SOURCE_AMI)' \
	  -var 'ami_name=jenkins_master_$(VERSION)' \
	packer.json

build-workers:
	$(eval VERSION = $(shell cat version.txt))
	rm -rf packer/workers.json
	cd packer/ && packer build \
	  -var 'mode=workers' \
	  -var 'region=$(AWS_REGION)' \
	  -var 'subnet_id=$(AWS_SUBNET)' \
	  -var 'source_ami=$(SOURCE_AMI)' \
	  -var 'ami_name=jenkins_workers_$(VERSION)' \
	packer.json

build-all:
	@make build-workers
	@make build-master

init:
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform init

apply:
	$(eval MASTER_AMI = $(shell cat packer/master.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))
	$(eval AWS_SG = $(shell cd terraform/security && terraform output id))
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform apply \
	  -var 'region=$(AWS_REGION)' \
	  -var 'vpc_id=$(VPC_ID)' \
	  -var 'subnet_id=$(AWS_SUBNET)' \
		-var 'security_group=$(AWS_SG)' \
	  -var 'ami=$(MASTER_AMI)' \
	  -var 'key_name=$(KEY_NAME)' \
	-auto-approve
	echo "You need to set the price for your spot instances"

install:
	@make date
	@make security
	@make build-all
	@make init
	@make apply

clear:
	$(eval MASTER_AMI = $(shell cat packer/master.json | grep artifact_id | cut -d':' -f3 | cut -d'"' -f1))
	$(eval AWS_SG = $(shell cd terraform/security && terraform output id))
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform && terraform destroy \
	  -var 'region=$(AWS_REGION)' \
	  -var 'vpc_id=$(VPC_ID)' \
	  -var 'subnet_id=$(AWS_SUBNET)' \
		-var 'security_group=$(AWS_SG)' \
	  -var 'ami=$(MASTER_AMI)' \
	  -var 'key_name=$(KEY_NAME)' \
	-auto-approve
	export AWS_DEFAULT_REGION="$(AWS_REGION)" && \
	cd terraform/security && terraform destroy \
	  -var 'vpc_id=$(VPC_ID)' \
	-auto-approve
	rm -rf packer/master.json
	rm -rf packer/workers.json