# Default variables
base_image="nvidia/cuda:10.2-cudnn7-devel-centos7"
base_os="centos7"
OTHER_ARGUMENTS=()

# User provided variables
for arg in "$@"
do
    case $arg in
        -bi*|--base_image*)
        base_image="${arg#*=}"
        shift
        ;;
        -bos*|--base_os*)
        base_os="${arg#*=}"
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
printf '##### %-88s #####\n' "Version 4.3.0"
printf '##### %-88s #####\n'
printf '#%.0s' {1..100}; printf '\n';
printf '##### %-88s #####\n' "Source: github.com/Mentos05/OpenCV-x64-gpu"
printf '#%.0s' {1..100}; printf '\n';
printf '#%.0s' {1..100}; printf '\n';
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Variables"
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Base Image:"
printf '##### %-88s #####\n' "$base_image"
printf '##### %-88s #####\n'
printf '##### %-88s #####\n' "Base Image OS:"
printf '##### %-88s #####\n' "$base_os"
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

# Start OpenCV Building and Packaging inside Docker container
echo "NOTE: Start building and packaging OpenCV."
# Centos 7 Building
if [ $base_os="centos7" ]; then
   mkdir $PWD/opencv-centos7-x64-rpm
   sudo docker run -it --rm --net=host --gpus all --runtime=nvidia -v $(pwd):/hostdata $base_image /bin/bash -C '/hostdata/buildAndPackageOpenCV_4.3.0-centos7.sh'
fi
# Ubuntu Building
if [ $base_os="ubuntu" ]; then
   mkdir $PWD/opencv-ubuntu-x64-deb
   sudo docker run -it --rm --net=host --gpus all --runtime=nvidia -v $(pwd):/hostdata $base_image /bin/bash -C '/hostdata/buildAndPackageOpenCV_4.3.0-ubuntu.sh'
echo "NOTE: Building and packaging OpenCV finished."
