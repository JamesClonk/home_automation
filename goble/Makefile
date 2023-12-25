.DEFAULT_GOAL := run
SHELL := /bin/bash

.PHONY: help
## help: prints this help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: run
## run: runs the application
run: clean
	GOARCH=amd64 GOOS=linux go run main.go

.PHONY: build
## build: builds the application for Raspberry Pi Zero W
build: clean
	@echo "Building binary ..."
	GOARM=6 GOOS=linux GOARCH=arm go build -o goble
	gzip goble

.PHONY: clean
## clean: cleans up binary files
clean:
	@echo "Cleaning up ..."
	go clean
	@rm -f goble || true
	@rm -f goble.gz || true

.PHONY: test
## test: runs go test with the race detector
test:
	GOARCH=amd64 GOOS=linux go test -v -race ./...

.PHONY: init
## init: sets up go modules
init:
	@echo "Setting up modules ..."
	@go mod init 2>/dev/null; go mod tidy && go mod vendor
