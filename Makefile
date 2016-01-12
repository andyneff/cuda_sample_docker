
NVIDIA_VERSION=$(shell sh -c "nvidia-smi -q  | grep 'Driver Version' | awk -F': ' '{print \$$2}'")
CUDA_VERSION=$(shell sh -c "/usr/local/cuda/bin/nvcc --version | tail -n 1 | awk '{print substr(\$$(NF),2)}'")

build:
	NVIDIA_VERSION=${NVIDIA_VERSION} CUDA_VERSION=${CUDA_VERSION} ./docker+/docker+.bsh Dockerfile.config > Dockerfile
	docker build -t cuda_example .

run:
	docker run -it --rm \
	           $$(ls /dev/nvidia* | sed 's|^|--device |') \
	           cuda_example