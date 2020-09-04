#!/bin/bash
# License: MIT. See license file in root directory
# Build OpenCV 4.4.0 on NVIDIA Docker image: nvidia/cuda:10.2-cudnn7-devel-centos7
# Copyright(c) Michael Gorkow (2020)

# Default variables
OPENCV_VERSION=4.4.0
DOWNLOAD_OPENCV_CONTRIB=YES
OPENCV_SOURCE_DIR=$HOME

# User provided variables
for arg in "$@"
do
    case $arg in
        -ocv*|--opencv_version*)
        OPENCV_VERSION="${arg#*=}"
        shift
        ;;
        *)
        OTHER_ARGUMENTS+=("$1")
        shift # Remove generic argument from processing
        ;;
    esac
done

# Install required packages
echo "NOTE: Installing required packages."
yum -y install epel-release
yum -y install git \
               gcc \
               gcc-c++ \
               cmake3 \
               file \
               gtk3-devel \
               libcanberra-gtk3 \
               python3 \
               python3-devel \
               python3-pip \
               python3-numpy \
               cmake \
               libpng-devel \
               jasper-devel \
               openexr-devel \
               libwebp-devel \
               libjpeg-turbo-devel \
               libtiff-devel \
               libdc1394-devel \
               tbb-devel numpy \
               eigen3-devel \
               freeglut-devel \
               jansson \
               libv4l-devel \
               make \
               openblas-devel \
               rpm-build
yum -y install gstreamer1-devel \
               gstreamer1-plugins-base-devel \
               gstreamer1-plugins-good
yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
yum -y install ffmpeg \
               ffmpeg-devel

# Download OpenCV source files
echo "NOTE: Downloading OpenCV source files"
cd $OPENCV_SOURCE_DIR
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}

# Download OpenCV contrib source files
if [ $DOWNLOAD_OPENCV_CONTRIB == "YES" ] ; then
 echo "NOTE: Downloading OpenCV contrib source files"
 # This is for the test data
 cd $OPENCV_SOURCE_DIR
 git clone https://github.com/opencv/opencv_contrib.git
 cd opencv_contrib
 git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}
fi

# Configure OpenCV build
echo "NOTE: Configuring OpenCV build"
cd $OPENCV_SOURCE_DIR/opencv
mkdir build
cd build

time cmake3 \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_opencv_world=OFF \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_CUDA=ON \
      -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
      -D ENABLE_FAST_MATH=ON \
      -D CUDA_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D WITH_LIBV4L=ON \
      -D WITH_GSTREAMER=ON \
      -D WITH_GSTREAMER_0_10=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_QT=OFF \
      -D WITH_GTK=ON \
      -D WITH_OPENGL=OFF \
      -D WITH_CUDNN=ON \
      -D OPENCV_DNN_CUDA=ON \
      -D ENABLE_FAST_MATH=ON \
      -D WITH_CUBLAS=ON \
      -D BUILD_opencv_python3=ON \
      -D OPENCV_EXTRA_MODULES_PATH=/root/opencv_contrib/modules \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D CUDNN_VERSION=7.6.5 \
      -D CUDNN_INCLUDE_DIR=/usr/include \
      -D CUDNN_LIBRARY=/usr/lib64/libcudnn.so \
      -D CPACK_BINARY_DEB=OFF \
      -D CPACK_BINARY_NSIS=OFF \
      -D CPACK_BINARY_RPM=ON \
      -D CPACK_BINARY_STGZ=OFF \
      -D CPACK_BINARY_TBZ2=OFF \
      -D CPACK_BINARY_TGZ=OFF \
      -D CPACK_BINARY_TZ=OFF \
      ../

if [ $? -eq 0 ] ; then
  echo "NOTE: CMake configuration make successful"
else
  # Try to make again
  echo "NOTE: CMake issues " >&2
  echo "NOTE: Please check the configuration being used"
  exit 1
fi

# Building OpenCV
echo "NOTE: Building OpenCV"
NUM_CPU=$(nproc)
time make -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "NOTE: OpenCV make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "NOTE: Make did not build " >&2
  echo "NOTE: Retrying ... "
  # Single thread this time
  make
  if [ $? -eq 0 ] ; then
    echo "NOTE: OpenCV make successful"
  else
    # Try to make again
    echo "NOTE: Make did not successfully build" >&2
    echo "NOTE: Please fix issues and retry build"
    exit 1
  fi
fi

# Installing OpenCV
echo "NOTE: Installing OpenCV"
make install
if [ $? -eq 0 ] ; then
   echo "NOTE: OpenCV installed in: /usr/local"
else
   echo "NOTE: There was an issue with the final installation"
   exit 1
fi

# Check installation
IMPORT_CHECK="$(python3 -c "import cv2 ; print(cv2.__version__)")"
if [[ $IMPORT_CHECK != *$OPENCV_VERSION* ]]; then
  echo "NOTE: There was an error loading OpenCV in the Python sanity test."
  echo "NOTE: The loaded version does not match the version built here."
  echo "NOTE: Please check the installation."
  echo "NOTE: The first check should be the PYTHONPATH environment variable."
fi

# Packaging OpenCV
echo "NOTE: Packaging OpenCV"
ldconfig
NUM_CPU=$(nproc)
time make package -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "NOTE: OpenCV make package successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "NOTE: Make package did not build " >&2
  echo "NOTE: Retrying ... "
  # Single thread this time
  make package
  if [ $? -eq 0 ] ; then
    echo "NOTE: OpenCV make package successful"
  else
    # Try to make again
    echo "NOTE: Make package did not successfully build" >&2
    echo "NOTE: Please fix issues and retry build"
    exit 1
  fi
fi

# Copy OpenCV files to host
if [[ $IMPORT_CHECK == *$OPENCV_VERSION* ]]; then
  cp /root/opencv/build/OpenCV-${OPENCV_VERSION}* /hostdata/opencv-centos7-x64-rpm/
  echo "NOTE: OpenCV Package Files copied to opencv-centos7-x64-rpm folder"
fi
