ARG DOCKER_USERNAME
ARG GHC_VERSION
FROM $DOCKER_USERNAME/alpine-haskell:$GHC_VERSION

RUN wget -O pwsh.tgz https://github.com/PowerShell/PowerShell/releases/download/v7.1.2/powershell-7.1.2-linux-alpine-x64.tar.gz && mkdir /opt/pwsh && tar -C /opt/pwsh -zxf pwsh.tgz && rm pwsh.tgz && apk add --update --no-cache libintl icu git
ENV PATH "/opt/pwsh:${PATH}"
