ARG NVIDIA="10.1-cudnn7-devel-ubuntu16.04"
FROM nvidia/cuda:${NVIDIA}
ARG PYTHON_VERSION=3.7
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*


RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include cython typing && \
     /opt/conda/bin/conda install -y -c pytorch magma-cuda101 && \
     /opt/conda/bin/conda install -y pytorch torchvision cudatoolkit=10.1 -c pytorch && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH
RUN pip --no-cache-dir install ninja
# This must be done before pip so that requirements.txt is available

RUN cd /opt && git clone https://github.com/pytorch/vision.git && cd vision && pip install -v .

WORKDIR /workspace
RUN chmod -R a+w /workspace
