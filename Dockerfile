# Pull base image
FROM openjdk:16-jdk-alpine

ENV SCALA_VERSION 2.13.3
ENV SBT_VERSION 1.4.1
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV PATH /sbt/bin:$PATH

RUN apk add --no-cache -U bash

# Install sbt
RUN \
  wget https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz && \
  tar -xzvf sbt-$SBT_VERSION.tgz && \
  rm sbt-$SBT_VERSION.tgz && \
  sbt sbtVersion -Dsbt.rootdir=true

# Install Scala
## Piping curl directly in tar
RUN \
  wget -O - https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/share/ && \
  mv /usr/share/scala-$SCALA_VERSION /usr/share/scala && \
  chown -R root:root /usr/share/scala && \
  chmod -R 755 /usr/share/scala && \
  ln -s /usr/share/scala/bin/scala /usr/local/bin/scala

# Define working directory
WORKDIR /usr/app/src

CMD sbt compile test pack publishLocal
