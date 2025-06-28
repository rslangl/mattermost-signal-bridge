FROM buildpack-deps:bullseye AS build

ARG SIGNAL_CLI_VERSION

WORKDIR /tmp
RUN mkdir -p /opt/signal-cli
RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz 
RUN tar xf signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz -C /opt

FROM alpine:3.22.0
COPY --from=build /opt /opt

RUN apk add --no-cache bash

WORKDIR /app
COPY bridge.sh .

RUN ln -sf /opt/signal-cli-"${SIGNAL_CLI_VERSION}"/bin/signal-cli /usr/local/bin/

ENTRYPOINT ["bash", "-c", "/app/bridge.sh"]
