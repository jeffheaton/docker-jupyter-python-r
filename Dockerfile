FROM tensorflow/tensorflow:2.11.1-gpu
LABEL maintainer="Jeff Heaton <jeff@jeffheaton.com>"

ENV TF_CPP_MIN_LOG_LEVEL=3
ENV TF_CPP_MIN_LOG_LEVEL=3

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata software-properties-common sudo build-essential git wget ffmpeg libssl-dev python3-dev && \
    ln -fs /usr/share/zoneinfo/Etc/GMT /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

WORKDIR /content/
RUN pip install \
    jupyter==1.0.0 \
    urllib3==1.26.5 \
    jupyterlab==3.6.2 \
    bayesian-optimization==1.4.2 \
    gym==0.26.2 \
    kaggle==1.5.13 \
    scikit-learn==1.2.2 \
    scipy==1.10.1 \
    pandas==1.5.3 \
    pandas-datareader==0.10.0 \
    matplotlib==3.7.1 \
    Pillow==9.4.0 \
    tqdm==4.65.0 \
    requests==2.28.2 \
    h5py==3.8.0 \
    PyYAML==6.0 \
    Flask==2.2.3 \
    boto3==1.26.97 && \
    git clone --depth 1 https://github.com/jeffheaton/t81_558_deep_learning && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 

COPY start-notebook.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh && \
    apt-get clean
CMD ["/usr/local/bin/start-notebook.sh"]
                                                                                                                  

