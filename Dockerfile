FROM centos:7

RUN yum groupinstall -y "Development Tools"

ENV NVIDIA_VERSION= \
    CUDA_VERSION=


#Assumes NVIDIA_VERSION environment variable is set, for example
#ENV NVIDIA_VERSION=352.55

RUN FILENAME=http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run && \
    if [ "$(curl -I ${FILENAME} -w '%{http_code}\n' -o /dev/null -s)" == "200" ]; then \
      curl -L ${FILENAME} -o nvidia_driver.run && \
      sh nvidia_driver.run -s --no-network --no-kernel-module && \
      rm nvidia_driver.run; \
    else \
      echo "Todo"; \
    fi


#Assumes CUDA_VERSION environment variable is set, for example
#ENV CUDA_VERSION=7.5.14

RUN CUDA_VERSION=${CUDA_VERSION:0:3} && \
    case "${CUDA_VERSION}" in \
      "7.5") \
        URL=http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run \
        ;; \
      "7.0") \
        URL=http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run \
        ;; \
      "6.5") \
        URL=http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run \
        ;; \
      "6.0") \
        URL=http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run \
        ;; \
      "5.5") \
        URL=http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/cuda_5.5.22_linux_64.run \
        ;; \
      *) \
        exit 1 \
        ;; \
    esac && \
    curl -L ${URL} -o cuda.run && \
    sh ./cuda.run -extract=/cuda && \
    sh /cuda/cuda-linux64*.run -noprompt && \
    sh /cuda/cuda-samples-linux*.run -noprompt -cudaprefix=/usr/local/cuda-${CUDA_VERSION} && \
    rm -f cuda.run && \
    rm -rf /cuda

CMD bash
