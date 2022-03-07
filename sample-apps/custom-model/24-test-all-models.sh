#!/bin/bash
set -eo pipefail
# get list of models from keras:
# >>> [model[0] for model in getmembers(tf.keras.applications, isfunction)]
# TF 2.4
declare -a arr=("DenseNet121" "DenseNet169" "DenseNet201" "EfficientNetB0" "EfficientNetB1" "EfficientNetB2" "EfficientNetB3" "EfficientNetB4" "EfficientNetB5" "EfficientNetB6" "EfficientNetB7" "InceptionResNetV2" "InceptionV3" "MobileNet" "MobileNetV2" "MobileNetV3Large" "MobileNetV3Small" "NASNetLarge" "NASNetMobile" "ResNet101" "ResNet101V2" "ResNet152" "ResNet152V2" "ResNet50" "ResNet50V2" "VGG16" "VGG19" "Xception")
for i in "${arr[@]}"
do
   echo "$i"
   docker run --gpus all panorama-custom-model python3 keras-model.py $i
done