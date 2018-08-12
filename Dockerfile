FROM ubuntu:18.04

# Common, note that two updates are needed
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata && \
    apt-get install -y  software-properties-common  && \
    apt-get install -y vim  && \
    apt-get install -y wget && \
    apt-get install -y libssl-dev

# Miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> /root/.bashrc && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda install pip
RUN conda install numpy

RUN conda install scipy

RUN pip install --upgrade pip
RUN pip install sklearn
RUN pip install pandas
RUN pip install pandas-datareader
RUN pip install matplotlib
RUN pip install pillow
RUN pip install requests
RUN pip install h5py
RUN pip install tensorflow==1.8.0
RUN pip install keras==2.2.0

RUN conda install jupyter

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# R
RUN apt-get update
RUN apt-get install -y r-base
#RUN conda install -c r ipython-notebook r-irkernel
RUN conda install -c r r-irkernel r-essentials -c conda-forge
COPY packages.r /root/packages.r

RUN ln -s /bin/tar /bin/gtar
RUN Rscript /root/packages.r

WORKDIR /root/

EXPOSE 8888

CMD ["sh", "-c", "jupyter notebook --ip=0.0.0.0 --allow-root"]
