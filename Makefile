
BASE_IMAGE=centos:7
NVIDIA_VERSION=$(shell sh -c "nvidia-smi -q  | grep 'Driver Version' | awk -F': ' '{print \$$2}'")
CUDA_VERSION=$(shell sh -c "/usr/local/cuda/bin/nvcc --version | tail -n 1 | awk '{print substr(\$$(NF),2)}'")

build:
	BASE_IMAGE=${BASE_IMAGE} NVIDIA_VERSION=${NVIDIA_VERSION} CUDA_VERSION=${CUDA_VERSION} ./docker+/docker+.bsh Dockerfile.config > Dockerfile
	docker build -t cuda_example .

install:
	@#docker build -t nvidia_driver -f Dockerfile_nvidia_driver .
	@#if docker inspect nvidia_driver_${NVIDIA_VERSION} > /dev/null 2>&1; then \
	@#  docker rm nvidia_driver_${NVIDIA_VERSION}; \
	@#fi
	@#docker run -v /usr/bin:/hostbin:ro -v /usr/lib64/nvidia:/hostlib64 --name nvidia_driver_${NVIDIA_VERSION} nvidia_driver
	docker volume create --name nvidia_driver_${NVIDIA_VERSION}
	docker run -it --rm -v nvidia_driver_${NVIDIA_VERSION}:/nvidia -v /usr:/host:ro centos bash
	docker run --rm -v nvidia_driver_${NVIDIA_VERSION}:/nvidia -v /usr:/host:ro centos cp -a /host/bin/nvidia* /nvidia/bin
	docker run --rm -v nvidia_driver_${NVIDIA_VERSION}:/nvidia -v /usr:/host:ro centos cp -ra /host/lib64/nvidia /nvidia/lib64

install2:
	mkdir -p nvidia/{bin,lib64}
	cp -a /usr/bin/nvidia* ./nvidia/bin/
	cp -ra /usr/lib64/nvidia/* ./nvidia/lib64/

uninstall:
	docker volume rm nvidia_driver_${NVIDIA_VERSION}

run:
	docker run -it --rm \
	           --volumes-from nvidia_driver_${NVIDIA_VERSION}:ro \
	           $$(ls /dev/nvidia* | sed 's|^|--device |') \
	           cuda_example

run2:
#	           -e LD_LIBRARY_PATH=/nvidia/lib64 \

	docker run -it --rm \
	           -v $$(pwd)/nvidia:/nvidia \
		   -v /tmp/.X11-unix:/tmp/.X11-unix \
                   -v /etc/yum.repos.d/cuda.repo:/etc/yum.repos.d/cuda.repo:ro \
		   -e DISPLAY=$${DISPLAY} \
		   --privileged \
	           $$(ls /dev/nvidia* | sed 's|^|--device |') \
	           $(BASE_IMAGE) sh -c "groupadd dev -og $$(id -g); useradd dev -ou $$(id -u) -g $$(id -g); bash"

