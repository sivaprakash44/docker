#!/bin/bash 

if [ ! -f dockerfile ]; then 
    echo -e "\e[31m Dockerfile missing\e[0m"
    exit 1
fi 

IMAGE=$(head -1 dockerfile | grep '^#' | sed -e 's/#//')
if [ -z "$IMAGE" ]; then 
    echo -e "\e[33m IMAGE_NAME is missing\e[0m"
    exit 2
fi 

echo -e "\e[35m>>>>>>>>>>STARTING IMAGING<<<<<<<<<<\e[0m"

docker build -t $IMAGE .  &>/tmp/image.log 
if [ $? -ne 0 ]; then 
    cat /tmp/image.log 
    exit 3 
fi 
echo -e "\e[35m>>>>>>>>>>END OF IMAGING<<<<<<<<<<\e[0m"

echo -n -e "\e[32mDO you want to push the Image? [Y|n]: \e[0m"
read choice
if [ -z "$choice" -o "$choice" == "Y" -o "$choice" == "y" ]; then 
    docker push $IMAGE
fi 

