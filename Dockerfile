FROM buildpack-deps:bullseye AS build

ARG SIGNAL_CLI_VERSION

WORKDIR /tmp
RUN mkdir -p /opt/signal-cli
RUN curl -o signal-cli.tar.gz -L https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz 
RUN tar xf signal-cli.tar.gz -C /opt/signal-cli --strip-components=1

FROM alpine:3.22.0
COPY --from=build /opt /opt

RUN apk add --no-cache bash openjdk21

WORKDIR /app
COPY bridge.sh .

RUN ln -sf /opt/signal-cli/bin/signal-cli /usr/local/bin/

ENTRYPOINT ["bash", "-c", "/app/bridge.sh"]
