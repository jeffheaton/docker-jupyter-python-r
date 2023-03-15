# docker-jupyter-python-r

This is a Docker image that I created to launch Jupyter notebooks that can be used in conjunction with my course and videos:

* [T81-558: Applications of Deep Learning](https://sites.wustl.edu/jeffheaton/t81-558/)
* [Heaton Research YouTube Channel](https://www.youtube.com/user/HeatonResearch)

Contains:

* TensorFlow 2.11
* PyTorch 1.13.1
* Anaconda Python 3.10
* Note: this docker image previously contained R-lang; which has not been used in my course for some time.
* Needed Python packages for my class

This docker image can be run with the following command.  You should mount a local path so that your notebooks can be saved outside the Docker container.

```
docker run -it --rm --gpus all -p 8888:8888 -v [local path]:/content/mnt/ docker-jupyter-python-r:latest
```

It is suggested that you mount a volumne to store your files. Any changes that you make to the docker container will be lost when you exit. If you wish to keep your container, then remove the --rm. See Docker command line instructions for more information on managing containers and images.

You will then access the notebook with this URL:

http://127.0.0.1:8888/?token=[your token]

You can get the token from the console output from the ```docker run``` command.