GOPATH:=$(shell go env GOPATH)
VERSION=$(shell git describe --tags --always)
APP='helloworld'

.PHONY: build
# build
build:
	mkdir -p bin
	GOARCH=amd64 GOOS=linux go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/$(APP)"-linux-amd64" ./... 
	GOARCH=arm64 GOOS=linux go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/$(APP)"-linux-arm64" ./... 
	GOARCH=amd64 GOOS=darwin go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/$(APP)"-darwin-amd64" ./... 
	GOARCH=arm64 GOOS=darwin go build -ldflags "-X main.Version=$(VERSION)" -o ./bin/$(APP)"-darwin-arm64" ./... 

.PHONY: docker
# build docker image
docker:
	docker buildx build \
      --platform linux/amd64,linux/arm64 \
	  -t mirrors2/$(APP):latest . --push

.PHONY: clean
# clean build
clean:
	rm -rf bin/

.PHONY: cleand
# clean docker
cleand:
	docker rmi $(docker images |grep none|awk '{print $3}') -f 
	docker rm $(docker ps -aq) 
	# docker rm $(docker ps -a |grep -v Up)

.PHONY: all
# generate all
all:


# show help
help:
	@echo ''
	@echo 'Usage:'
	@echo ' make [target]'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
	helpMessage = match(lastLine, /^# (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 2, RLENGTH); \
			printf "\033[36m%-22s\033[0m %s\n", helpCommand,helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
