DOMAIN = $(shell cat ./projects/DOMAIN)
REVERSE-DOMAIN = $(shell res=""; doms=`echo $(DOMAIN)|sed 's/\./ /g'|rev`; for dom in $${doms}; do r=`echo $${dom}|rev`; if [ "$${res}" == "" ]; then res="$${r}"; else res="$${res}.$${r}"; fi; done; echo $$res)
FULL-PROJECT = $(REVERSE-DOMAIN).$$project

all: create-domain create

create: projects-dir check-param check-nonexist actual-create copy-skel mod

projects-dir:
	@mkdir -p ./projects

check-domain:
	@if [ "$$domain" == "" ]; then \
	echo "Empty domain! Use 'make create-domain domain=foo.com'"; \
	exit 125; \
	fi

create-domain: projects-dir check-domain
	@echo $$domain > ./projects/DOMAIN

check-param:
	@if [ "$$project" == "" ]; then \
	echo "Empty project! Use 'make create project=somename'"; \
	exit 127; \
	fi

check-nonexist:
	@if [ -d ./projects/$(FULL-PROJECT) ]; then \
	echo "Project already exists!"; \
	exit 129; \
	fi

actual-create:
	@mkdir ./projects/$(FULL-PROJECT)
	@mkdir -p $$GOPATH/src/$(DOMAIN)
	@ln -s `pwd`/projects/$(FULL-PROJECT) $$GOPATH/src/$(DOMAIN)/$(FULL-PROJECT)

copy-skel:
	@cp ./skel/* ./projects/$(FULL-PROJECT)/
	@sed -i '' "s/gomobile_project_package/$(FULL-PROJECT)/g" ./projects/$(FULL-PROJECT)/AndroidManifest.xml

mod:
	@curdir=`pwd`; cd ./projects/$(FULL-PROJECT)/; go mod init $(DOMAIN)/$(FULL-PROJECT); go mod why; cd $$curdir
