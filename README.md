# docker-rpi-pico-build-env
Build environment for Raspberry Pi Pico with pico-sdk in it. See https://github.com/raspberrypi/pico-sdk for more info.

## Run to Build

Simply run `docker run --rm -it -v $(pwd):/code shyd/rpi-pico-build-env` from the folder with the `CMakeLists.txt` in it.

## Quick-start your own project

1. Set up your project to point to use the Raspberry Pi Pico SDK

    1. Copy [pico_sdk_import.cmake](https://github.com/raspberrypi/pico-sdk/blob/master/external/pico_sdk_import.cmake)
     from the SDK into your project directory
    1. Setup a `CMakeLists.txt` like:

        ```cmake
        cmake_minimum_required(VERSION 3.13)

        # initialize the SDK based on PICO_SDK_PATH
        # note: this must happen before project()
        include(pico_sdk_import.cmake)

        project(my_project)

        # initialize the Raspberry Pi Pico SDK
        pico_sdk_init()

        # rest of your project

        ```

1. Write your code (see [pico-examples](https://github.com/raspberrypi/pico-examples) or the [Raspberry Pi Pico C/C++ SDK](https://rptl.io/pico-c-sdk) documentation for more information)

    About the simplest you can do is a single source file (e.g. hello_world.c)

    ```c
    #include <stdio.h>
    #include "pico/stdlib.h"

    int main() {
       setup_default_uart();
       printf("Hello, world!\n");
       return 0;
    }
    ```
    And add the following to your `CMakeLists.txt`:

    ```cmake
    add_executable(hello_world
       hello_world.c
    )

    # Add pico_stdlib library which aggregates commonly used features
    target_link_libraries(hello_world pico_stdlib)

    # create map/bin/hex/uf2 file in addition to ELF.
    pico_add_extra_outputs(hello_world)
    ```

    Note this example uses the default UART for _stdout_;
    if you want to use the default USB see the [hello-usb](https://github.com/raspberrypi/pico-examples/tree/master/hello_world/usb) example.

1. Make your target from the build directory you created.
      ```sh
      $ docker run --rm -it -v $(pwd):/code shyd/rpi-pico-build-env
      ```

1. Look into the `build` directory. You now have `hello_world.elf` to load via a debugger, or `hello_world.uf2` that can be installed and run on your Raspberry Pi Pico via drag and drop.
