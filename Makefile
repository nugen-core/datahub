SHELL := /bin/bash
RESOURCE_NAME_PREFIX := nugen-dev-tf-dcbb
VERSION := $$(head -n 1 VERSION)

.PHONY: aws-login
aws-login:
	aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 764586527967.dkr.ecr.eu-west-1.amazonaws.com

datahub-push-image: aws-login
	echo $(VERSION)
	if [[ $$(docker manifest inspect 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:$(VERSION)>/dev/null; echo $$?) == 1 ]]; \
	then { \
		docker tag nugen-dcbb-datahub:latest 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:latest ; \
		docker push 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:latest ; \
		docker tag nugen-dcbb-datahub:latest 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:$(VERSION) ; \
		docker push 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:$(VERSION) ; \
  	} fi

datahub-pull-latest-image: aws-login
	docker pull 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:latest
	docker tag 764586527967.dkr.ecr.eu-west-1.amazonaws.com/$(RESOURCE_NAME_PREFIX)-datahub-frontend-react:latest nugen-dcbb-datahub-frontend-react:latest


.PHONY: datahub-build
datahub-build:
	docker-compose -f docker/docker-compose.yml build datahub-frontend-react
