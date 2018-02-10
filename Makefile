NAMESPACE := emcniece
PROJECT := raenv
PLATFORM := linux
ARCH := amd64
DOCKER_IMAGE := $(NAMESPACE)/$(PROJECT)

VERSION := $(shell cat VERSION)
GITSHA := $(shell git rev-parse --short HEAD)

all: help

help:
	@echo "---"
	@echo "IMAGE: $(DOCKER_IMAGE)"
	@echo "VERSION: $(VERSION)"
	@echo "---"
	@echo "make deps - install build dependencies"
	@echo "make build - build binary for the target environment"
	@echo "make watch - monitor & rebuild with Realize"
	#@echo "make vet - run vet & gofmt checks"
	#@echo "make test - run tests"
	@echo "make clean - remove build artifacts"
	@echo "make image - compile Docker image"
	@echo "make run - start Docker contaner"
	@echo "make run-test - run 'npm test' on container"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

deps:
	go get github.com/tools/godep
	go get github.com/tockins/realize
	go get -u github.com/spf13/viper
	go get -u github.com/spf13/cobra/cobra
	go get github.com/mitchellh/go-homedir
	go get github.com/inconshreveable/mousetrap
	godep save

build-dir:
	@rm -rf build && mkdir build

dist-dir:
	@rm -rf dist && mkdir dist

build: build-dir
	go build
	cp ./raenv ./build
	go install

watch:
	realize start

clean:
	go clean
	rm -fr ./build
	rm -fr ./dist

image:
	docker build -t $(DOCKER_IMAGE):$(VERSION) \
		-f Dockerfile .

run:
	docker run -d $(DOCKER_IMAGE):$(VERSION)

run-debug:
	docker run -d $(DOCKER_IMAGE):$(VERSION) tail -f /dev/null

docker:
	@echo "Pushing $(DOCKER_IMAGE):$(VERSION)"
	docker push $(DOCKER_IMAGE):$(VERSION)

release: docker
	@echo "Pushing $(DOCKER_IMAGE):latest"
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):latest
