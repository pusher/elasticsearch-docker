.DEFAULT_GOAL:=help

## Print this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[1m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)


GIT_DESC := $(shell git describe --always --dirty --tags 2>/dev/null || echo "undefined")
VERSION  := 5.6
TAG      := ${VERSION}-${GIT_DESC}

# Image URL to use all building/pushing image targets
IMG ?= quay.io/pusher/elasticsearch-docker

## build docker image(s)
docker-build:
	@echo -e "\033[36mBuilding ==> $(IMG):$(VERSION)\033[0m"
	docker build --build-arg VERSION=${VERSION} . -f Dockerfile.${VERSION} -t ${IMG}:${TAG}

TAGS ?= latest
## docker tag
docker-tag:
	@for tag in $(TAGS); do \
		echo -e "\033[36mTagging ==> $(IMG):$(TAG) as $${tag}\033[0m"; \
		docker tag ${IMG}:${TAG} ${IMG}:$${tag} || exit 11; \
	done

## Push the docker image
PUSH_TAGS ?= ${TAG} latest
docker-push:
	@for tag in $(PUSH_TAGS); do \
		echo -e "\033[36mPushing ==> $(IMG):$${tag}\033[0m"; \
		docker push ${IMG}:$${tag}; \
	done
