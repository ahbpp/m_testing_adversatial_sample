#!/usr/bin/env bash

#############
# Function
#############


exe_file=../model_mutation/generate_mutated_models.py

modelName="lenet"
modelPath="../build-in-resource/pretrained-model/lenet.pkl"
accRation=0.9
dataType=0
numMModels=100
mutatedRation=0.01
opType="NAI"
savePath="../artifacts_eval/modelMuation/"
device=-1


python $exe_file --modelName ${modelName} \
                 --modelPath ${modelPath} \
                 --accRation ${accRation} \
                 --dataType ${dataType} \
                 --numMModels  ${numMModels}   \
                 --mutatedRation  ${mutatedRation} \
                 --opType  ${opType} \
                 --savePath  ${savePath} \
                 --device  ${device}