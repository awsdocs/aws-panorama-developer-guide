#!/bin/bash
set -eo pipefail
declare -a arr=("DenseNet121" "DenseNet169" "DenseNet201" "InceptionResNetV2" "InceptionV3" "MobileNet" "MobileNetV2" "NASNetLarge" "NASNetMobile" "ResNet101" "ResNet101V2" "ResNet152" "ResNet152V2" "ResNet50" "ResNet50V2" "VGG16" "VGG19" "Xception")
for i in "${arr[@]}"
do
   echo "$i"
   docker run --gpus all panorama-custom-model python3 keras-model.py $i
done