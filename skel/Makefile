VERSION = $(shell cat ./VERSION)
PACKAGE = gomobile_project_package
PACKAGE_FILE = $(PACKAGE)-$(VERSION).apk
#BUILD = $(shell git rev-parse HEAD)
BUILD = 12345
BDATE = $(shell date -u '+%Y-%m-%d_%I:%M:%S%p_UTC')
GO_VERSION = $(shell go version|awk '{print $$3}')

all: deps build install

deps:
	@go get golang.org/x/mobile/cmd/gomobile

build:
	@gomobile build -a -trimpath -v -x -ldflags "-w -X main.Build=$(BUILD) -X main.BuildDate=$(BDATE) -X main.GoVersion=$(GO_VERSION) -X main.Version=$(VERSION)" -o $(PACKAGE_FILE)

install:
	@adb install -r $(PACKAGE_FILE)
