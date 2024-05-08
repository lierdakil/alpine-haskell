ARG DOCKER_USERNAME
ARG GHC_VERSION
FROM $DOCKER_USERNAME/alpine-haskell:$GHC_VERSION

RUN wget -O pwsh.tgz https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/powershell-7.3.4-linux-alpine-x64.tar.gz && mkdir /opt/pwsh && tar -C /opt/pwsh -zxf pwsh.tgz && rm pwsh.tgz && apk add --update --no-cache libintl icu git
ENV PATH "/opt/pwsh:${PATH}"
