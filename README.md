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
than that version, but now newer... I do not have a reliable way of knowing the max
version. It's not documented clearly. To make with a specific version of cuda

    make CUDA_VERSION=7.0

