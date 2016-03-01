
BASE_IMAGE=centos:7
NVIDIA_VERSION=$(shell sh -c "nvidia-smi -q  | grep 'Driver Version' | awk -F': ' '{print \$$2}'")
CUDA_VERSION=$(shell sh -c "/usr/local/cuda/bin/nvcc --version | tail -n 1 | awk '{print substr(\$$(NF),2)}'")

build:
	#BASE_IMAGE=$(BASE_IMAGE) NVIDIA_VERSION=$(NVIDIA_VERSION) CUDA_VERSION=$(CUDA_VERSION) ./docker+/docker+.bsh Dockerfile.config > Dockerfile
	docker build -t cuda_example .

install:
	if docker volume inspect nvidia_driver_$(NVIDIA_VERSION) > /dev/null 2>&1; then \
          docker volume rm nvidia_driver_$(NVIDIA_VERSION) ; \
        fi
	docker volume create --name nvidia_driver_$(NVIDIA_VERSION)
	docker run --rm -v nvidia_driver_${NVIDIA_VERSION}:/nvidia -v /usr:/host:ro $(BASE_IMAGE) bash -c "mkdir /nvidia/{bin,lib64} && cp -a /host/bin/nvidia* /nvidia/bin && cp -ra /host/lib64/nvidia/* /nvidia/lib64"

install2:
	mkdir -p nvidia/{bin,lib64}
	cp -a /usr/bin/nvidia* ./nvidia/bin/
	cp -ra /usr/lib64/nvidia/* ./nvidia/lib64/

uninstall:
	docker volume rm nvidia_driver_${NVIDIA_VERSION}

run:
	docker run -it --rm \
	           -v nvidia_driver_${NVIDIA_VERSION}:/usr/local/nvidia:ro \
	           $$(ls /dev/nvidia* | sed 's|^|--device |') \
		   -v /tmp/.X11-unix:/tmp/.X11-unix \
                   -e DISPLAY=$${DISPLAY} \
	           cuda_example sh -c "groupadd dev -og $$(id -g); useradd dev -ou $$(id -u) -g $$(id -g); bash"

run2:
#	           -e LD_LIBRARY_PATH=/nvidia/lib64 \

	docker run -it --rm \
	           -v nvidia_driver_${NVIDIA_VERSION}:/usr/local/nvidia \
		   -v /tmp/.X11-unix:/tmp/.X11-unix \
                   -v /etc/yum.repos.d/cuda.repo:/etc/yum.repos.d/cuda.repo:ro \
		   -e DISPLAY=$${DISPLAY} \
		   --privileged \
	           $$(ls /dev/nvidia* | sed 's|^|--device |') \
	           $(BASE_IMAGE) sh -c "groupadd dev -og $$(id -g); useradd dev -ou $$(id -u) -g $$(id -g); bash"

