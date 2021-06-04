#!/bin/bash
set -eo pipefail
declare -a arr=("DenseNet121" "InceptionV3" "DenseNet201" "ResNet152" "MobileNet" "InceptionResNetV2" "Xception" "ResNet50" "ResNet50V2" "VGG16" "NASNetLarge" "DenseNet169" "VGG19" "ResNet101" "ResNet152V2" "NASNetMobile" "MobileNetV2" "ResNet101V2")

for i in "${arr[@]}"
do
   echo "$i"
   docker run --gpus all panorama-custom-model python3 keras-model.py $i
done