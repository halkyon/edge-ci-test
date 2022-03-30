.PHONY: build-image
build-image:
	docker build --pull -t storjlabs/edge-ci:latest .

.PHONY: push-image
push-image:
	docker push storjlabs/edge-ci:latest

.PHONY: clean-image
clean-image:
	docker rmi storjlabs/edge-ci:latest
