FROM ubuntu:22.04
LABEL maintainer="Jeff Heaton <jeff@jeffheaton.com>"

# Perform updates as root
USER root
WORKDIR /tmp
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y tzdata software-properties-common sudo build-essential git vim wget ffmpeg libssl-dev
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

# Create notebook user
ENV NB_USER nbuser
ENV NB_UID 1000
ENV HOME /content/
RUN useradd -m -s /bin/bash -d ${HOME} -N -G sudo -u $NB_UID $NB_USER
WORKDIR ${HOME}
USER ${NB_USER}

# Miniconda
ENV MINI_PATH ${HOME}/miniconda
RUN  \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ${MINI_PATH} && \
    rm ~/miniconda.sh && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'export PATH='+${MINI_PATH}+'/bin:$PATH' >> ${HOME}/.bashrc && \
    rm -rf /tmp/*
ENV PATH ${MINI_PATH}/bin:$PATH
RUN conda init

# Tensorflow
RUN conda install -y jupyter && \
    conda install -c conda-forge cudatoolkit=11.2.2 cudnn=8.1.0 && \ 
    mkdir -p ${MINI_PATH}/etc/conda/activate.d && \
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > ${MINI_PATH}/etc/conda/activate.d/env_vars.sh && \
    pip install --upgrade pip && \
    pip install tensorflow==2.11.* && \
    rm -rf /tmp/*

RUN conda install -y scikit-learn scipy pandas pandas-datareader matplotlib pillow tqdm requests h5py pyyaml flask boto3
RUN pip install bayesian-optimization gym kaggle 
RUN conda install pytorch==1.13.1 torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
RUN git clone --depth 1 https://github.com/jeffheaton/t81_558_deep_learning
COPY --chown=nbuser readme_t81_558.ipynb ${HOME}/readme_t81_558.ipynb
EXPOSE 8888
CMD conda run --no-capture-output -n base jupyter notebook --ip=0.0.0.0