#!/bin/bash

# Sets the most important java binaries with update-alternatives.
# Jdk needs to be unzipped and moved to dir /lib/jvm (default jdk location).

echo "Updating java alternatives, add ${1}"

if [ ! -d "/lib/jvm/${1}" ]; then
  echo "Jdk ${1} does not exist in directory '/lib/jvm/'"
  exit 1
fi

sudo update-alternatives --install /usr/bin/java java /lib/jvm/${1}/bin/java 1
sudo update-alternatives --install /usr/bin/javac javac /lib/jvm/${1}/bin/javac 1
sudo update-alternatives --install /usr/bin/jshell jshell /lib/jvm/${1}/bin/jshell 1
sudo update-alternatives --install /usr/bin/javadoc javadoc /lib/jvm/${1}/bin/javadoc 1
sudo update-alternatives --install /usr/bin/jdeps jdeps /lib/jvm/${1}/bin/jdeps 1