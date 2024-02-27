# references
# https://docs.flutter.dev/get-started/install/linux
# https://medium.com/@kevinwilliams.dev/building-a-flutter-web-container-3b13f4b2bd0c
# https://medium.com/@codemax120/flutter-web-with-docker-06cee1839adb

# build and run in separate environments
FROM ubuntu:latest AS build-env

# build arguments
ARG FLUTTER_VERSION=3.19.1


ENV DEBIAN_FRONTEND=noninteractive

# install utils
RUN apt-get update
# xz-utils are an extension for tar to extract xz files
RUN apt-get install -y wget tar xz-utils git
RUN apt-get clean

# Install flutter
WORKDIR /
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz
RUN tar xf flutter_linux_$FLUTTER_VERSION-stable.tar.xz
RUN git config --global --add safe.directory /flutter
# add flutter to path
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter config --no-cli-animations
RUN flutter config --enable-web

# build app
RUN mkdir /app/
COPY ./ /app/
WORKDIR /app/
RUN flutter build web

# runtime image
FROM nginx:1.25-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html

EXPOSE 80
