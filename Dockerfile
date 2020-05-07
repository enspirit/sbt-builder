# Pull base image
FROM openjdk:11.0.2-jdk-oraclelinux7

ENV SCALA_VERSION 2.13.2
ENV SBT_VERSION 1.3.9

# Install Scala
## Piping curl directly in tar
# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.rpm https://bintray.com/sbt/rpm/download_file?file_path=sbt-$SBT_VERSION.rpm && \
  rpm -i sbt-$SBT_VERSION.rpm && \
  rm sbt-$SBT_VERSION.rpm && \
  yum -y update && \
  yum -y install sbt && \
  sbt sbtVersion

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/share && \
  mv /usr/share/scala-$SCALA_VERSION /usr/share/scala && \
  chown -R root:root /usr/share/scala && \
  chmod -R 755 /usr/share/scala && \
  ln -s /usr/share/scala/bin/scala /usr/local/bin/scala

# Define working directory
WORKDIR /usr/app/src

CMD sbt compile test pack publishLocal
