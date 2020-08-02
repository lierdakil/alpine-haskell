include ../../config.mk

.PHONY: all
all: image

.PHONY: image
image:
	docker build \
	  --build-arg GHC_VERSION=$(TARGET_GHC_VERSION) \
	  --build-arg DOCKER_USERNAME=$(DOCKER_USERNAME) \
	  --tag $(DOCKER_USERNAME)/alpine-haskell:$(TARGET_GHC_VERSION)-pwsh \
	  $(CURDIR)

.PHONY: publish
publish: image
	docker push $(DOCKER_USERNAME)/alpine-haskell:$(TARGET_GHC_VERSION)-pwsh
