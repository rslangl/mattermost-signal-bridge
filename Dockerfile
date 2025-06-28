FROM buildpack-deps:bullseye AS build

ARG SIGNAL_CLI_VERSION

WORKDIR /tmp
RUN mkdir -p /opt/signal-cli
RUN curl -o signal-cli.tar.gz -L https://github.com/AsamK/signal-cli/releases/download/v"${SIGNAL_CLI_VERSION}"/signal-cli-"${SIGNAL_CLI_VERSION}".tar.gz 
RUN tar xf signal-cli.tar.gz -C /opt/signal-cli --strip-components=1

FROM debian:bookworm-slim
COPY --from=build /opt /opt

RUN apt update && apt install -y --no-install-recommends \
  wget \
  gnupg \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public \
  | tee /etc/apt/trusted.gpg.d/adoptium.asc

RUN echo "deb https://packages.adoptium.net/artifactory/deb bullseye main" \
  | tee /etc/apt/sources.list.d/adoptium.list

RUN apt update && apt install -y temurin-21-jdk \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY bridge.sh .

RUN ln -sf /opt/signal-cli/bin/signal-cli /usr/local/bin/

ENTRYPOINT ["bash", "-c", "/app/bridge.sh"]
