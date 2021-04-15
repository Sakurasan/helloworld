# https://eddycjy.com/posts/go/gin/2018-08-26-makefile/
.PHONY: build clean tool lint docker help

all: build

build:
	go build -v .

tool:
	go tool vet . |& grep -v vendor; true
	gofmt -w .

lint:
	golint ./...

clean:
	rm -rf main helloworld
	go clean -i .

docker:
	docker build -t mirrors2/helloworld:latest . 

help:
	@echo "make: compile packages and dependencies"
	@echo "make tool: run specified go tool"
	@echo "make lint: golint ./..."
	@echo "make clean: remove object files and cached files"
	@echo "make docker: build docker image"