DEFAULT_GOAL:=help

## Print this help
#  EG: 'make' or 'make help'
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[1m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)

VERSION      := $(shell git describe --always --dirty --tags 2>/dev/null || echo "undefined")
SHORT_SHA    := $(shell git describe --always)
BRANCH       := $(shell git branch --show-current | sed "s|/|-|g")
PUSH_TAGS    ?= ${SHORT_SHA}
DEFAULT_TAGS ?= ${VERSION},${BRANCH}-${SHORT_SHA},${BRANCH}-${VERSION}
FINAL_TAGS   ?= ${DEFAULT_TAGS},${PUSH_TAGS}
TAGS         ?= latest


# project specific settings
IMG       ?= quay.io/pusher/elasticsearch-docker


## Build the docker image
docker-build:
	docker build --build-arg VERSION=${VERSION} -t ${IMG}:${VERSION} . -f Dockerfile.5.6
	@echo -e "\033[36m==> Built $(IMG):$(VERSION)\033[0m"

## tag the docker image
#  applies tags to the built container
docker-tag:
	@IFS=","; set -e ; tags=${FINAL_TAGS}; for tag in $${tags}; do docker tag ${IMG}:${VERSION} ${IMG}:$${tag}; echo -e "\033[36m==> Tagged $(IMG):$(VERSION) as $${tag}\033[0m"; done

## Push the docker image and tags
#  add extra tags with the $PUSH_TAGS (comma seperated) variable
docker-push:
	@IFS=","; set -e ; tags=${FINAL_TAGS}; for tag in $${tags}; do docker push ${IMG}:$${tag}; echo -e "\033[36m==> Pushed $(IMG):$${tag}\033[0m"; done

