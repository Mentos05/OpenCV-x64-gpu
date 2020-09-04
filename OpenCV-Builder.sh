# Default variables
BASE_IMAGE="nvidia/cuda:10.2-cudnn7-devel-centos7"
OPENCV_VERSION="4.4.0"
OTHER_ARGUMENTS=()

# User provided variables
for arg in "$@"
do
    case $arg in
        -bi*|--base_image*)
        BASE_IMAGE="${arg#*=}"
        shift
        ;;
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

printf '#%.0s' {1..100}; printf '\n';
printf '#%.0s' {1..100}; printf '\n';
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Building and packaging OpenCV"
printf '##### %-88s #####\n' "Version $OPENCV_VERSION"
printf '##### %-88s #####\n'
printf '#%.0s' {1..100}; printf '\n';
printf '##### %-88s #####\n' "Source: github.com/Mentos05/OpenCV-x64-gpu"
printf '#%.0s' {1..100}; printf '\n';
printf '#%.0s' {1..100}; printf '\n';
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Variables"
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Base Image:"
printf '##### %-88s #####\n' "$BASE_IMAGE"
printf '##### %-88s #####\n'
printf '#%.0s' {1..100}; printf '\n';

while true; do
    read -p "Are these settings correct?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Pulling / Updating base image
echo "NOTE: Pulling/Updating $BASE_IMAGE"
sudo docker pull $BASE_IMAGE

# Start OpenCV Building and Packaging inside Docker container
echo "NOTE: Start building and packaging OpenCV."
mkdir $PWD/opencv-centos7-x64-rpm
sudo docker run -it --rm --net=host --gpus all --runtime=nvidia -v $(pwd):/hostdata $BASE_IMAGE /bin/bash -C "/hostdata/buildAndPackageOpenCV-centos7.sh --opencv_version=$OPENCV_VERSION"
