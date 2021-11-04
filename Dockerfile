FROM ubuntu:20.04

ARG BRANCH_OR_TAG=master
ENV DEBIAN_FRONTEND=noninteractive
ENV PICO_SDK_PATH=/pico-sdk
ENV PICO_SDK_POST_LIST_DIRS=/pico-extras
ENV PIMORONI_PICO_PATH=/pimoroni-pico

ENV BUILD_TYPE=Release

RUN env \
  && apt-get update \
  && apt-get install -q -y build-essential git cmake gcc-arm-none-eabi libnewlib-arm-none-eabi python3 doxygen graphviz clang-tidy libstdc++-arm-none-eabi-newlib \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 -b $BRANCH_OR_TAG -q https://github.com/raspberrypi/pico-sdk.git $PICO_SDK_PATH
WORKDIR $PICO_SDK_PATH
RUN git submodule update --init

RUN git clone --depth=1 -b $BRANCH_OR_TAG -q https://github.com/raspberrypi/pico-extras.git $PICO_SDK_POST_LIST_DIRS
WORKDIR $PICO_SDK_POST_LIST_DIRS
RUN git submodule update --init

RUN git clone --depth=1 -b main -q https://github.com/pimoroni/pimoroni-pico.git $PIMORONI_PICO_PATH
WORKDIR $PIMORONI_PICO_PATH
RUN git submodule update --init

WORKDIR /code

CMD mkdir -p /code/build && cd build && cmake .. -DCMAKE_BUILD_TYPE=$BUILD_TYPE && make
