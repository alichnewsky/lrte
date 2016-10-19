#!/bin/bash

# not on MacoSX.
READLINK=readlink

# use current dir by default
INSTALL_DIR=${1:-.}

INSTALL_PATH=$($READLINK -f ${INSTALL_DIR})


echo downloading last LRTE release RPMs into $INSTALL_PATH

curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-runtime-1.0-0.amd64.rpm -o ${INSTALL_PATH}/lrtev2-runtime-1.0-0.amd64.rpm && \
curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-crosstoolv2-gcc-4.9-1.0-8.239985svn.x86_64.rpm        -o ${INSTALL_PATH}/lrtev2-crosstoolv2-gcc-4.9-1.0-8.239985svn.x86_64.rpm && \
curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-crosstoolv2-clang-4.0-1.0-8.281170svn.x86_64.rpm      -o ${INSTALL_PATH}/lrtev2-crosstoolv2-clang-4.0-1.0-8.281170svn.x86_64.rpm && \
curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-crosstoolv2-ispc-1.9.2dev-1.0-8.d4a8afdsvn.x86_64.rpm -o ${INSTALL_PATH}/lrtev2-crosstoolv2-ispc-1.9.2dev-1.0-8.d4a8afdsvn.x86_64.rpm

# it should be able to run without dependencies on theses, but for some reasons isn't
curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-headers-1.0-0.amd64.rpm -o ${INSTALL_PATH}/lrtev2-headers-1.0-0.amd64.rpm 

curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-debuginfo-1.0-0.amd64.rpm -o ${INSTALL_PATH}/lrtev2-debuginfo-1.0-0.amd64.rpm && \
curl -sL https://github.com/alichnewsky/lrte/releases/download/v2.2_0/lrtev2-gde-1.0-0.amd64.rpm -o ${INSTALL_PATH}/lrtev2-gde-1.0-0.amd64.rpm 


#curl -sL https://github.com/bazelbuild/bazel/releases/download/0.3.1/bazel-0.3.1-installer-linux-x86_64.sh -o ${INSTALL_PATH}/bazel-0.3.1-installer-linux-x86_64.sh && \
#    curl -sL https://github.com/bazelbuild/bazel/releases/download/0.3.1/bazel-0.3.1-installer-linux-x86_64.sh.sha256  -o ${INSTALL_PATH}/bazel-0.3.1-installer-linux-x86_64.sh.sha256 && \
#    sha256sum -c ${INSTALL_PATH}/bazel-0.3.1-installer-linux-x86_64.sh.sha256


