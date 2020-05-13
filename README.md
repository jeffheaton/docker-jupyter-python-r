# docker-jupyter-python-r

This is a Docker image that I created to launch Jupyter notebooks that can be used in conjunction with my course:

* [T81-558: Applications of Deep Learning](https://sites.wustl.edu/jeffheaton/t81-558/)
* [Heaton Research YouTube Channel](https://www.youtube.com/user/HeatonResearch)

Contains:

* TensorFlow 2.0
* Anaconda Python 3.7
* R 3.6
* Needed Python packages for my class

This docker image can be run with the following command.  You should mount a local path so that your notebooks can be saved outside the Docker container.

```
docker run -it --rm -p 8888:8888 -v [local path]:/root/mount/ docker-jupyter-python-r:latest
```

You will then access the notebook with this URL:

http://127.0.0.1:8888/?token=[your token]

You can get the token from the console output from the ```docker run``` command.