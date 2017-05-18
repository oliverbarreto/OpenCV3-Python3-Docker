FROM kaakaa/opencv-contrib-python3
MAINTAINER Oliver Barreto "oliver.barreto.online@gmail.com"

RUN pip3 install jupyter
RUN pip3 install matplotlib
RUN pip3 install nupmy

RUN mkdir /tmp/notebooks

CMD /usr/local/bin/jupyter-notebook --ip=0.0.0.0 --notebook-dir=/tmp/notebooks --port=8888 --no-browser

# docker run -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/data -p 8888:8888 -it opencv3-python3

