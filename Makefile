include config.mk

.PHONY: build
build:
	docker build \
	  --build-arg GHC_VERSION=$(TARGET_GHC_VERSION) \
	  --build-arg CABAL_VERSION=$(TARGET_CABAL_VERSION) \
	  --tag $(DOCKER_USERNAME)/alpine-haskell:$(TARGET_GHC_VERSION) \
	  --cache-from $(DOCKER_USERNAME)/alpine-haskell:9.2.3 \
	  $(CURDIR)

.PHONY: publish
publish: build
	docker push $(DOCKER_USERNAME)/alpine-haskell:$(TARGET_GHC_VERSION)
