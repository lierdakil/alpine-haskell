# GHC, Alpine, Stack, and Docker

This is a barebones version of <https://github.com/lierdakil/alpine-haskell-stack> that just uses prebuilt GHC instead of builing it.

# Quick Start

```bash
make
```

You can specify a particular version via

```bash
make TARGET_GHC_VERSION=8.8.4 build
```

(at the time of writing, only a few versions have an alpine binary available)

If you plan to publish to docker hub, adjust `DOCKER_USERNAME` in `config.mk`
