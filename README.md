# Creating a Docker Image with OpenCV 3 and Python 3


[Full Credits to this great post from Matthias Rueedlinger](http://to.predict.ch/hacking/2017/02/12/opencv-with-docker.html)

Installing a new verstion of OpenCV on a mac is hard, there are not binaries around for a while, and compiling it from source has been mission impossible at least, for me. And believe me that I've tried. I've followed this [great post from PyImageSearch](http://www.pyimagesearch.com/2016/12/05/macos-install-opencv-3-and-python-3-5/)

But there is another option. Run the newest OpenCV version and Python 3 from a docker image and use Jupyter Notebook. Let's put them all together.

## Dockerfile
Let's create a docker file using a docker image with opencv. So let's search the docker hub:
```
FROM kaakaa/opencv-contrib-python3
MAINTAINER Oliver Barreto "oliver.barreto.online@gmail.com"

RUN pip3 install jupyter
RUN pip3 install matplotlib
RUN pip3 install nupmy

RUN mkdir /tmp/notebooks

CMD /usr/local/bin/jupyter-notebook --ip=0.0.0.0 --notebook-dir=/tmp/notebooks --port=8888 --no-browser
```
And build the image
```
docker build -t opencv3-python3 .

```
## Running the image
```
docker run -v /Volumes/HDData/Users/Oliver/Dropbox/Developer/Dev/Python/iNotebooks:/data -p 8888:8888 -it --rm opencv3-python3
```


## Sharing devices (webcam, USB drives, etc) with Docker
Sharing devices with Docker is described in [this Stackoverflow post](http://stackoverflow.com/questions/34302096/sharing-devices-webcam-usb-drives-etc-with-docker)

## Using the camera... it just (Don't) Work on a Mac :(
According to this opst in Stackoverflow [Using webcam connected to MacBook inside a Docker container](https://apple.stackexchange.com/questions/265281/using-webcam-connected-to-macbook-inside-a-docker-container) it just don't work [according to](https://docs.docker.com/docker-for-mac/faqs/#what-is-the-benefit-of-hyperkit) this is not possible.


## Example
/to/predict
Articles
About Me
Contact

OpenCV 3.x and Python 3 with Docker
Feb 12, 2017
Installing OpenCV1 from source is hard. But when you want to use the newest version of OpenCV there is no way around to install OpenCV from source. You may find pre-build OpenCV packages but they probably are outdated.
To install a pre-build but outdated OpenCV package have a look at my post Raspberry Pi and OpenCV (2.4.x).
Compiling OpenCV is for most users quite challenging. But there is an elegant solution to run the newest OpenCV version and Python 3 without starting your compiler.
A pretty interesting solution is to use a Docker2 image to run OpenCV with a Jupyter3 notebook. In this post we will see how you can use Docker, OpenCV and a Jupyter notebook server together.
Note: Docker containers wrap a piece of software in a complete filesystem that contains everything needed to run: code, runtime, system tools, system libraries – anything that can be installed on a server. This guarantees that the software will always run the same, regardless of its environment.4
Build the Docker OpenCV image
We will create a Docker image with OpenCV installed. To run OpenCV code from the Docker container we will use a Jupyter notebook. First you should install Docker on your machine. Then you can create a Dockerfile. A Dockerfile is a text document that contains all the commands to assemble an image. This image can then run in our container.
We don’t have to start from scratch, luckily there is already a Docker OpenCV / Python 3 image5. We can extend the existing image and use it as a staring point. We slightly modify the image so that we can use Jupyter and other Python libraries like matplotlib6.
FROM jjanzic/docker-python3-opencv

RUN pip3 install jupyter
RUN pip3 install matplotlib

CMD /usr/local/bin/jupyter-notebook --ip=0.0.0.0
Next we have to build the Docker image from our Dockerfile. With the argument ‘-t’ we can set the name of our image.
docker build -t opencv-docker .
Start the Docker OpenCV container
Our new Docker image ‘opencv-docker’ is built, now it’s time to start the container with the new image. The ‘docker run’ command will start our container and run the Jupyter notebook server. With option ‘-p’ we tell Docker how to map the container port to the port of the local machine. In our example we will use the default port 8888 for Jupyter, but you could change the port for your local machine.
With the command line option ‘-v’ you can mount a volume and share data between your machine and the Docker container. The following command will mount the directory ‘/your_path’ on your machine into the directory ‘/data’ in the Docker container. This allows us to share data between your local machine and the Docker container.
docker run -v /your_path:/data -p 8888:8888 -it opencv-docker
Note: When you are using Linux you could also share devices like a Webcam with Docker7. To share a device you could use the ’–device’ argument.
After you have started the container you should see an output like this.
[I 21:59:46.044 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 21:59:46.135 NotebookApp] Serving notebooks from local directory: /
[I 21:59:46.135 NotebookApp] 0 active kernels 
[I 21:59:46.135 NotebookApp] The Jupyter Notebook is running at: http://0.0.0.0:8888/?token=2435850cfb91ee7b08f789512ab36ad25d4466bc690fd31d
[I 21:59:46.136 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[W 21:59:46.138 NotebookApp] No web browser found: could not locate runnable browser.
[C 21:59:46.138 NotebookApp] 
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=2435850cfb91ee7b08f789512ab36ad25d4466bc690fd31d
[I 22:00:01.825 NotebookApp] 302 GET / (172.17.0.1) 6.64ms
[I 22:00:01.836 NotebookApp] 302 GET /tree? (172.17.0.1) 2.45ms
On the console output you will see a url (e.g. http://0.0.0.0:8888/?token=abcdef…) which you have to copy/paste into your browser to connect for the first time to the Jupyter notebook server.
Our first OpenCV example
The Jupyter notebook server is running and now you can try the face recognition example from OpenCV.8 In this example we want to detect faces and eyes in an image.
First we create a new notebook and import the required libraries and load the CascadeClassifier for the eyes and faces. Then we load our image and convert the image to grayscale.
%matplotlib inline

import numpy as np
import matplotlib.pyplot as plt
import cv2


face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')
img = cv2.imread('me.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
Next we try to detect faces. When we found a face we also try to detect the eyes in the area of the face. Of course we will mark the faces and eyes in the image with rectangles.
faces = face_cascade.detectMultiScale(gray, 1.3, 5)
for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
    roi_gray = gray[y:y+h, x:x+w]
    roi_color = img[y:y+h, x:x+w]
    eyes = eye_cascade.detectMultiScale(roi_gray)
    for (ex,ey,ew,eh) in eyes:
        cv2.rectangle(roi_color,(ex,ey),(ex+ew,ey+eh),(0,255,0),2)
At the end we plot the image with all the faces and eyes we have found.
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))

I hope this article was useful for you and gives you good idea how to get started with OpenCV and Docker.
References
OpenCV, http://opencv.org/ ↩

Docker, https://www.docker.com/ ↩

Jupyter, http://jupyter.org/ ↩

What is docker?, https://www.docker.com/what-docker ↩

Docker image with python 3.6 and opencv 3.2, https://hub.docker.com/r/jjanzic/docker-python3-opencv/ ↩

matplotlib, http://matplotlib.org/ ↩

Sharing devices (webcam, USB drives, etc) with Docker, http://stackoverflow.com/questions/34302096/sharing-devices-webcam-usb-drives-etc-with-docker ↩

Face Detection using Haar Cascades, http://docs.opencv.org/3.2.0/d7/d8b/tutorial_py_face_detection.html ↩

/to/predict - Personal Blog (Python, R, Machine Learning, Data Analytics and Data Science) Social
2015 - 2017, Matthias Rueedlinger. Disclaimer

    
