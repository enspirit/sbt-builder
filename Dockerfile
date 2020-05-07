# Pull base image
FROM java:8

ENV SCALA_VERSION 2.12.6
ENV SBT_VERSION 0.13.9

# Install Scala
## Piping curl directly in tar
RUN \
  echo 'deb http://archive.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list && \
  sed -i '/jessie-updates/d' /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 && \
  apt-get -o Acquire::Check-Valid-Until=false update && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc && \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get install -y sbt && \
  apt-get clean && \
  sbt sbtVersion

# Define working directory
WORKDIR /usr/app/src

CMD sbt compile test pack publishLocal
