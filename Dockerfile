# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y g++

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git

## Add source code to the build stage.
ADD . /qmc-decoder
WORKDIR /qmc-decoder

RUN git submodule update --init
WORKDIR /qmc-decoder/build
RUN cmake ..
RUN make

#Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /qmc-decoder/build/qmc-decoder /
