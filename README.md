# Building & Packaging OpenCV 4.4.0 on Centos 7 
This project allows you to build and package OpenCV 4.4.0 inside the nvidia/cuda:10.2-cudnn7-devel-centos7 container from NVIDIA.
Afterwards you'll have the package files on the host machine for quick deployment in other containers rather than building it again and again.
Benefit: Fast OpenCV deployment and small container sizes.

CUDA, CUDNN, GStreamer, FFMPEG, Nonfree-stuff, Python-Support, etc. is enabled. (see Build Information)

### Requirements
* System with NVIDIA GPU (tested with RTX2070)
* Linux OS (tested with Ubuntu 18.04 and Centos 7)
* NVIDIA Driver (tested with version 430/450)
* [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker)

### How To
1. Clone this repository.
```
git clone https://github.com/Mentos05/OpenCV-x64-gpu
```
2. Run "OpenCV-Builder.sh". Package files will be located in "opencv-centos7-x64-rpm" folder.
```
bash OpenCV-Builder.sh
```
3. Install your package files on host or in other containers.
```
yum install opencv-centos7-x64-rpm/*.rpm
```

The OpenCV-Builder.sh script accepts user variables.<br>
Append them to OpenCV-Builder.sh with --variable=value<br>
Example:<br>
```
bash OpenCV-Builder.sh --base_image=opencv_version
```

| Variable | Description | Default |
| ------ | ------ | ------ |
| base_image | Base image to use | nvidia/cuda:10.2-cudnn7-devel-centos7 |
| opencv_version | OpenCV version to build | 4.4.0 |

Note: The script was tested with default values. Other RHEL based images and/or OpenCV versions might work.

### OpenCV Build Information


### Contact
If you like to discuss how computer vision can be applied to your problems, you're of course free to contact me.<br>

| Channel | Adress |
| ------ | ------ |
| Email Work | michael.gorkow@sas.com |
| Email Private | michaelgorkow@gmail.com |
| LinkedIn | [LinkedIn Profile](https://www.linkedin.com/in/michael-gorkow-08353678/) |
| Twitter | [Twitter Profile](https://twitter.com/GorkowMichael) |
