FROM alpine:3.12 AS base

# Add ghcup's bin directory to the PATH so that the versions of GHC it builds
# are available in the build layers
ENV GHCUP_INSTALL_BASE_PREFIX=/
ENV PATH=/.ghcup/bin:$PATH

# Install the basic required dependencies to run 'ghcup' and 'stack'
# bash and shadow needed for stack --docker
# openssh-client needed for stack private packages
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
        openssh-client

# Download, verify, and install ghcup
RUN echo "Downloading and installing ghcup" &&\
    GHCUP_VERSION="0.1.8" &&\
    GHCUP_SHA256="7ffcd4c3de156e895b648c75a36c762be2a4932883f3cd598f7a483c97d4a8a9  /usr/bin/ghcup" &&\
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
    STACK_VERSION=2.3.1 &&\
    STACK_SHA256="4bae8830b2614dddf3638a6d1a7bbbc3a5a833d05b2128eae37467841ac30e47  stack-${STACK_VERSION}-linux-x86_64-static.tar.gz" &&\
    cd /tmp &&\
    wget -P /tmp/ "https://github.com/commercialhaskell/stack/releases/download/v${STACK_VERSION}/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz" &&\
    if ! echo -n "${STACK_SHA256}" | sha256sum -c -; then \
        echo "stack-${STACK_VERSION} checksum failed" >&2 &&\
        exit 1 ;\
    fi ;\
    tar -xvzf /tmp/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz &&\
    cp -L /tmp/stack-${STACK_VERSION}-linux-x86_64-static/stack /usr/bin/stack &&\
    rm /tmp/stack-${STACK_VERSION}-linux-x86_64-static.tar.gz &&\
    rm -rf /tmp/stack-${STACK_VERSION}-linux-x86_64-static &&\
    stack config set system-ghc --global true
