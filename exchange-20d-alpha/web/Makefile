account = $(shell aws sts get-caller-identity --query "Account" --output text)
image = $(account).dkr.ecr.us-east-1.amazonaws.com/exchange-web:$(version)
stage = dev
include configs/$(stage)


login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(account).dkr.ecr.us-east-1.amazonaws.com

build:
	docker build -t $(image) .

push: login
	@docker push $(image)

namespace:
	@cat kubernetes/namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -

deploy: namespace
	@cat kubernetes/deployment.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|ACCOUNT|$(account)|g;s|HOSTNAME|$(hostname)|g" | kubectl apply -f -
	@kubectl -n $(namespace) rollout status deployment/exchange-api

delete: 
	@cat kubernetes/deployment.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|ACCOUNT|$(account)|g" | kubectl delete -f -