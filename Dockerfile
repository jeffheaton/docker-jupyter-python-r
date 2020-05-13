FROM ubuntu:20.10

# Common, note that two updates are needed
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata software-properties-common git vim wget libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> /root/.bashrc && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH

RUN wget https://raw.githubusercontent.com/jeffheaton/t81_558_deep_learning/master/tensorflow.yml && \
    conda install pip jupyter && \
    conda env create -v -f tensorflow.yml && \ 
    conda init bash && \
    rm -rf /var/lib/apt/lists/*

RUN rm tensorflow.yml && \
    activate tensorflow  && \
    /opt/conda/envs/tensorflow/bin/python -m ipykernel install --user --name tensorflow --display-name "Python 3.7 (tensorflow)"  && \
    rm -rf /var/lib/apt/lists/*

# Reinforcement learning
RUN apt update  && \
    apt install -y xvfb ffmpeg  && \
    /opt/conda/envs/tensorflow/bin/pip install 'gym==0.10.11' 'imageio==2.4.0' PILLOW 'pyglet==1.3.2' pyvirtualdisplay && \
    /opt/conda/envs/tensorflow/bin/pip install --upgrade tensorflow-probability && \
    /opt/conda/envs/tensorflow/bin/pip install tf-agents  && \
    rm -rf /var/lib/apt/lists/* 

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends fonts-dejavu gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# R
#RUN conda install -c r ipython-notebook r-irkernel
RUN apt-get update && \
    apt-get install -y r-base && \
    conda install -c r r-irkernel r-essentials -c conda-forge && \
    rm -rf /var/lib/apt/lists/*

COPY packages.r /root/packages.r

RUN ln -s /bin/tar /bin/gtar && \
    Rscript /root/packages.r

WORKDIR /root/

EXPOSE 8888

CMD ["sh", "-c", "jupyter notebook --ip=0.0.0.0 --allow-root"]


