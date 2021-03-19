FROM shyd/zsh

ARG BRANCH_OR_TAG=master
ENV DEBIAN_FRONTEND=noninteractive
ENV PICO_SDK_PATH=/pico-sdk
RUN env \
  && apt-get update \
  && apt-get install -q -y build-essential git cmake gcc-arm-none-eabi libnewlib-arm-none-eabi python3 doxygen graphviz \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 -b $BRANCH_OR_TAG -q https://github.com/raspberrypi/pico-sdk.git $PICO_SDK_PATH
WORKDIR $PICO_SDK_PATH
RUN git submodule update --init

WORKDIR /code

CMD mkdir -p /code/build && cd build && cmake .. && make
