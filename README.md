# README #

Simple example for a docker with cuda support using docker+

## Usage ##

    git clone https://github.com/andyneff/cuda_sample_docker.git .
    git submodule init
    git submodule update
    make
    make run

Now that you are inside the docker

    cd /usr/local/cuda/samples/1_Utilities/deviceQuery
    make
    ./deviceQuery

## FAQ ###

1. What if I want to build a docker with a different version of the nvidia driver
or cuda library?

Well, be careful on the first part. As far as I know YOU CAN NOT deviate from the
nvidia driver at all, up or down. It's a bad idea to try. So unless you are just
pre-building images to ship, don't do this. For example:

    make NVIDIA_VERSION=352.55

Now changing versions of cuda, is much... safer. The rule is: Your nvidia driver
can support up to a specific version of cuda. It will also work with versions older
than that version, but now newer... To make with a specific version of cuda

    make CUDA_VERSION=7.0

The only reliable way I know to check what the maximum version of cuda your 
nvidia driver will support is to run the deviceQuery sample cuda program, and 
look at the final lines. Similar to this:

    deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 7.5, CUDA Runtime Version = 5.5, NumDevs = 3, Device0 = Tesla K20c, Device1 = GeForce GTX 580, Device2 = GeForce GTX 680
    Result = PASS

This says that while I'm using cuda 5.5 for this test, My nvidia driver 
version (352.55 in this case) can support up to cuda 7.5. 
