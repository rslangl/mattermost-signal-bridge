# Mattermost-Signal bridge

Goal: provide a middleware component that connects a privately hosted
Mattermost instance with a Signal group chat, which requires:

* A mattermost bot account with webhook access
* [Signal-CLI](https://github.com/AsamK/signal-cli), an unofficial CLI tool for interfacing with Signal
* Bridge script/daemon that connects these two

## Setup

### Mattermost integration

1. **Create incoming webhook**

* In Mattermost, go to `Integrations/Incoming webhooks` and specify the channel to post to
* Copy the webhook URL

2. **Create outgoing webhook**

* In Mattermost, go to `Integrations/Outgoing webhooks`
* Set trigger words, callback URL, and the source channel
* Save the created token

### Setup Signal interface

1. **Install and configure Signal-CLI**

* Build and install using Gradle

2. **Use Signal-CLI as a client**

* Register Signal phone number to use as a client:

```shell
./bin/signal-cli -u +4799887766 register
./bin/signal-cli -u +4799887766 verify
```

* Invite the above number to the group we are targeting, and save the group ID

### Setup middleware

1. **Setup Signal listener with Signal-CLI (polling/receive)**

* Listen for incoming Signal messages and forward them to Mattermost using the corresponding webhook URL

2. **Setup Signal listener with Signal-CLI (send)**

* Listen for incoming Mattermost messages and forward them to the Signal group
using `signal-cli send` and the provided group ID

## Usage

### Preparation

<!-- markdownlint-disable MD013 -->
As per the official documentation for [Signal-CLI](https://github.com/AsamK/signal-cli?tab=readme-ov-file#usage), the number to be used by the client needs to be registered, tl;dr:
<!-- markdownlint-enable MD013 -->

```shell
# register
$ signal-cli -a <phonenumber> register

# wait for verification code to be received
$ signal-cli -a <phonenumber> verify <code>
```

### Run image

Build and run the image with the necessary arguments:

```shell
# build
$ docker build --build-arg SIGNAL_CLI_VERSION=0.13.16 -t bridge .

# run
$ docker run -e PHONE_NO=<phonenumber> \
  -e SIGNAL_GROUP_ID=<group> \
  -e MATTERMOST_WEBHOOK_URL=<webhook> \
  bridge
```
