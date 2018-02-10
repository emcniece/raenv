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
	@echo "make build - build binary for the target environment"
	@echo "make deps - install build dependencies"
	#@echo "make vet - run vet & gofmt checks"
	#@echo "make test - run tests"
	@echo "make clean - remove build artifacts"
	@echo "make image - compile Docker image"
	@echo "make run - start Docker contaner"
	@echo "make run-test - run 'npm test' on container"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

build-dir:
	@rm -rf build && mkdir build

dist-dir:
	@rm -rf dist && mkdir dist

build: build-dir
	CGO_ENABLED=0 GOOS=$(PLATFORM) GOARCH=$(ARCH) godep go build raenv -ldflags "-X main.Version=$(VERSION) -X main.GitSHA=$(GITSHA)" -o build/$(PROJECT)-$(PLATFORM)-$(ARCH)

deps:
	go get github.com/tools/godep
	go get github.com/spf13/cobra/cobra
	go get github.com/inconshreveable/mousetrap
	godep save

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
