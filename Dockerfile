ARG CUDA_VERSION=13_1
ARG MANYLINUX_BASE=manylinux_2_28
ARG ARCH=x86_64

FROM quay.io/pypa/${MANYLINUX_BASE}_${ARCH}:latest

ARG CUDA_VERSION
ARG ARCH

SHELL ["/bin/bash", "-c"]

RUN { [ ${ARCH} = "aarch64" ] && export CUDA_REPO_ARCH="sbsa" || export CUDA_REPO_ARCH="x86_64"; } && \
    dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/${CUDA_REPO_ARCH}/cuda-rhel8.repo

# error mirrorlist.centos.org doesn't exists anymore.
RUN sed -i 's/mirror.centos.org/vault.centos.org/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^#.*baseurl=http/baseurl=http/g' /etc/yum.repos.d/*.repo && \
    sed -i 's/^mirrorlist=http/#mirrorlist=http/g' /etc/yum.repos.d/*.repo

# Turns '12_8' -> '12-8' for use below
RUN export CUDA_DASH_VERSION=$(echo ${CUDA_VERSION} | sed 's/_/-/g') && \
  export CUDA_MAJOR_VERSION=${CUDA_VERSION%_[0-9]*} && \
  dnf install --setopt=obsoletes=0 -y \
  cuda-nvcc-${CUDA_DASH_VERSION} \
  cuda-cudart-devel-${CUDA_DASH_VERSION} \
  cuda-driver-devel-${CUDA_DASH_VERSION} \
  libcurand-devel-${CUDA_DASH_VERSION} \
  libcudnn9-devel-cuda-${CUDA_MAJOR_VERSION} \
  libcublas-devel-${CUDA_DASH_VERSION} \
  libnccl \
  libnccl-devel

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
