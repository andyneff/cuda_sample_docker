# README #

Simple example for a docker with cuda support using docker+

## Usage ##

    git clone https://github.com/andyneff/cuda_sample_docker.git .
    git submodule init
    git submodule update
    make
    make run
    cd /usr/local/cuda/samples/1_Utilities/deviceQuery
    make
    ./deviceQuery