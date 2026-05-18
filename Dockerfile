ARG CUDA_VERSION=12.8
ARG REGISTRY=quay.io
ARG OWNER=gpu-ci-demo
ARG MANYLINUX_BASE=manylinux_2_28_x86_64
ARG BASE_IMAGE=$REGISTRY/$OWNER/$MANYLINUX_BASE:latest
FROM $BASE_IMAGE


dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/x86_64/cuda-rhel8.repo

# error mirrorlist.centos.org doesn't exists anymore.
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo

# Turns '12.8' -> '12-8' for use below...
CUDA_DASH_VERSION=$(sed -i s/\./-/g ${{ matrix.cuda-version }})

dnf install --setopt=obsoletes=0 -y \
  cuda-nvcc-12-8-12.8.93-1 \
  cuda-cudart-devel-12-8-12.8.90-1 \
  libcurand-devel-12-8-10.3.9.90-1 \
  libcudnn9-devel-cuda-12-9.10.2.21-1 \
  libcublas-devel-12-8-12.8.4.1-1 \
  libnccl-2.26.2-1+cuda12.8 \
  libnccl-devel-2.26.2-1+cuda12.8

ln -s cuda-12.8 /usr/local/cuda
