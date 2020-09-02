# Building & Packaging OpenCV 4.3.0 on Centos 7 
This project allows you to build and package OpenCV 4.3.0 inside the nvidia/cuda:10.2-cudnn7-devel-centos7 container from NVIDIA.
Afterwards you'll have the package files on the host machine for quick deployment in other containers rather than building it again and again.
Benefit: Fast OpenCV deployment and small container sizes.

CUDA, CUDNN, GStreamer, FFMPEG, Nonfree-stuff, Python-Support, etc. is enabled. (see Build Information)

### Requirements
* System with NVIDIA GPU (tested with RTX2070)
* Linux OS (tested with Ubuntu 18.04 and Centos 7)
* NVIDIA Driver (tested with version 430/450)
* [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker)

### How To
0. If you already have a version of the base image (nvidia/cuda:10.2-cudnn7-devel-centos7) make sure to update it.
```
git pull nvidia/cuda:10.2-cudnn7-devel-centos7
```
1. Clone this repository
```
git clone https://github.com/Mentos05/OpenCV-x64-gpu
```
2. Run "OpenCV-Builder.sh"
```
bash OpenCV-Builder.sh
```
3. Find the package files in "opencv-centos7-x64-deb"
4. Install your package files with yum install -f on host or in other containers

Make sure you are running your containers with the nvidia runtime.

### OpenCV Build Information Centos7

### Contact
If you like to discuss how computer vision can be applied to your problems, you're of course free to contact me.<br>

| Channel | Adress |
| ------ | ------ |
| Email Work | michael.gorkow@sas.com |
| Email Private | michaelgorkow@gmail.com |
| LinkedIn | [LinkedIn Profile](https://www.linkedin.com/in/michael-gorkow-08353678/) |
| Twitter | [Twitter Profile](https://twitter.com/GorkowMichael) |
