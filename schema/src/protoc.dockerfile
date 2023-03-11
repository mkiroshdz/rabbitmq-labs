FROM ubuntu:bionic

RUN apt-get update -y

RUN apt-get install apt-transport-https curl gnupg -y
RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
RUN mv bazel-archive-keyring.gpg /usr/share/keyrings
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install g++ git bazel -y

WORKDIR /
RUN git clone https://github.com/protocolbuffers/protobuf.git
WORKDIR /protobuf
RUN git checkout v22.2
RUN bazel build :protoc :protobuf
RUN cp bazel-bin/protoc /usr/local/bin