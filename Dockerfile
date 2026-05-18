ARG CUDA_VERSION
ARG MANYLINUX_BASE
ARG MANYLINUX_REGISTRY=quay.io
ARG MANYLINUX_OWNER=pypa

ARG BASE_IMAGE=$MANYLINUX_REGISTRY/$MANYLINUX_OWNER/$MANYLINUX_BASE:latest

FROM $BASE_IMAGE

ARG CUDA_VERSION

SHELL ["/bin/bash", "-c"]

RUN dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

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
  libcurand-devel-${CUDA_DASH_VERSION} \
  libcudnn9-devel-cuda-${CUDA_MAJOR_VERSION} \
  libcublas-devel-${CUDA_DASH_VERSION} \
  libnccl \
  libnccl-devel

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
