FROM alpine:3.12 AS base

# Add ghcup's bin directory to the PATH so that the versions of GHC it builds
# are available in the build layers
ENV GHCUP_INSTALL_BASE_PREFIX=/
ENV PATH=/.ghcup/bin:$PATH

# Install the basic required dependencies to run 'ghcup' and 'stack'
# bash and shadow needed for stack --docker
# openssh-client needed for stack private packages
# binutils-gold needed for ld.gold
# zlib-static is just a common dependency
RUN apk upgrade --no-cache &&\
    apk add --no-cache \
        curl \
        gcc \
        g++ \
        gmp-dev \
        ncurses-dev \
        libffi-dev \
        zlib-dev \
        make \
        xz \
        tar \
        perl \
        bash \
        shadow \
        openssh-client \
        binutils-gold \
        zlib-static

# Download, verify, and install ghcup
RUN echo "Downloading and installing ghcup" &&\
    GHCUP_VERSION="0.1.16.2" &&\
    GHCUP_SHA256="d5e43b95ce1d42263376e414f7eb7c5dd440271c7c6cd9bad446fdeff3823893  /usr/bin/ghcup" &&\
    cd /tmp &&\
    wget -O /usr/bin/ghcup "https://downloads.haskell.org/~ghcup/${GHCUP_VERSION}/x86_64-linux-ghcup-${GHCUP_VERSION}" &&\
    if ! echo -n "${GHCUP_SHA256}" | sha256sum -c -; then \
        echo "ghcup checksum failed" >&2 &&\
        exit 1 ;\
    fi ;\
    chmod +x /usr/bin/ghcup

ARG GHC_VERSION
RUN ghcup install ghc $GHC_VERSION &&\
    ghcup set ghc $GHC_VERSION

ARG CABAL_VERSION
RUN ghcup install cabal $CABAL_VERSION &&\
    ghcup set cabal $CABAL_VERSION

# Download, verify, and install stack
RUN echo "Downloading and installing stack" &&\
    STACK_VERSION=2.7.3 &&\
    STACK_DIRNAME="stack-${STACK_VERSION}-linux-x86_64" &&\
    STACK_ARCHIVE="${STACK_DIRNAME}.tar.gz" &&\
    STACK_SHA256="a6c090555fa1c64aa61c29aa4449765a51d79e870cf759cde192937cd614e72b  ${STACK_ARCHIVE}" &&\
    cd /tmp &&\
    wget -P /tmp/ "https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/${STACK_ARCHIVE}" &&\
    if ! echo -n "${STACK_SHA256}" | sha256sum -c -; then \
        echo "stack-${STACK_VERSION} checksum failed" >&2 &&\
        exit 1 ;\
    fi ;\
    tar -xvzf /tmp/${STACK_ARCHIVE} &&\
    cp -L /tmp/${STACK_DIRNAME}/stack /usr/bin/stack &&\
    rm /tmp/${STACK_ARCHIVE} &&\
    rm -rf /tmp/${STACK_DIRNAME} &&\
    stack config set system-ghc --global true
