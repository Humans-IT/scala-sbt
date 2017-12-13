#
# Scala and sbt Dockerfile
#
# https://github.com/humansit/scala-sbt
#

# Pull base image
FROM openjdk:8u151

# Env variables
ENV SCALA_VERSION 2.12.4
ENV SBT_VERSION 1.0.2

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
RUN \
  echo "Installing SBT" \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

RUN \
  echo "Installing Build tools" \
  apt-get update && \
  apt-get install rpm && \
  apt-get install git && \
  apt-get install python


RUN \
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
  python get-pip.py

RUN pip install awscli

# Define working directory
WORKDIR /root
