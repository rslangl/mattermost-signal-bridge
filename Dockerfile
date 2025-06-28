FROM buildpack-deps:bullseye AS build

ARG SIGNAL_CLI_VERSION

WORKDIR /tmp
RUN wget https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz 
RUN tar xf signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz -C /opt



