PROJECT-DIR = ./projects
DOMAIN = $(shell cat $(PROJECT-DIR)/DOMAIN)
REVERSE-DOMAIN = $(shell res=""; doms=`echo $(DOMAIN)|sed 's/\./ /g'|rev`; for dom in $${doms}; do r=`echo $${dom}|rev`; if [ "$${res}" == "" ]; then res="$${r}"; else res="$${res}.$${r}"; fi; done; echo $$res)
FULL-PROJECT = $(REVERSE-DOMAIN).$$project

all: create-domain create

create: projects-dir check-param check-nonexist actual-create copy-skel mod

projects-dir:
	@mkdir -p $(PROJECT-DIR)

check-domain:
	@if [ "$$domain" == "" ]; then \
	echo "Empty domain! Use 'make create-domain domain=foo.com'"; \
	exit 125; \
	fi

create-domain: projects-dir check-domain
	@echo $$domain > $(PROJECT-DIR)/DOMAIN

check-param:
	@if [ "$$project" == "" ]; then \
	echo "Empty project! Use 'make create project=somename'"; \
	exit 127; \
	fi

check-nonexist:
	@if [ -d $(PROJECT-DIR)/$(FULL-PROJECT) ]; then \
	echo "Project already exists!"; \
	exit 129; \
	fi

actual-create:
	@mkdir $(PROJECT-DIR)/$(FULL-PROJECT)
	@mkdir -p $$GOPATH/src/$(DOMAIN)
	@ln -s `pwd`/$(PROJECT-DIR)/$(FULL-PROJECT) $$GOPATH/src/$(DOMAIN)/$(FULL-PROJECT)

copy-skel:
	@cp ./skel/* $(PROJECT-DIR)/$(FULL-PROJECT)/
	@sed -i '' "s/gomobile_project_package/$(FULL-PROJECT)/g" $(PROJECT-DIR)/$(FULL-PROJECT)/AndroidManifest.xml

mod:
	@curdir=`pwd`; cd $(PROJECT-DIR)/$(FULL-PROJECT)/; go mod init $(DOMAIN)/$(FULL-PROJECT); go mod why; cd $$curdir

list-projects:
	@ls $(PROJECT-DIR)/|grep -v 'DOMAIN'

check-build-project:
	@if [ "$$project" == "" ]; then \
	echo "Empty project! Use 'make build-project project=foo.com'"; \
	exit 131; \
	fi

build-project: check-build-project
	@curdir=`pwd`; cd $(PROJECT-DIR)/$$project; make build; cd $$curdir

unlink-all:
	@for project in $(shell make list-projects); do unlink $$GOPATH/src/$(DOMAIN)/$$project 2>/dev/null; done; exit 0

link-all:
	@for project in $(shell make list-projects); do ln -s `pwd`/$(PROJECT-DIR)/$$project $$GOPATH/src/$(DOMAIN)/$$project; done

build-all:
	@for project in $(shell make list-projects); do make build-project project=$$project; done
