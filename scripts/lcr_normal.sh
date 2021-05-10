#!/usr/bin/env bash

#############
# Function
#############


exe_file=../lcr_auc/mutated_testing.py
analyze_file=../lcr_auc/lcr_auc_analysis.py

#echo -e "NOTE: Our experiments are only based on two datasets: mnist and cifar10,\n
#         but it is a piece of cake to extend to other datasets only providing a \n
#         proper pytorch-style data loader tailored to himself datasets."
#
#echo "To quickly label change rate and auc statistics , we provide a group of default parameters，do you want to quickly start the
#program?y/n"
#read choice

####################
# read parameters
####################
dataType=0
device=-1
useTrainData="False"
batchModelSize=2
maxModelsUsed=100
seedModelName="lenet"
testType="normal"  # normal,adv,wl
mutatedModelsPath="../artifacts_eval/modelMuation/nai0.01/lenet/"
testSamplesPath="../build-in-resource/dataset/mnist/raw/"
test_result_folder="../lcr_results/mnist/lenet/nai/1e-2p/normal_test/"
seedModelPath="../build-in-resource/pretrained-model/lenet.pkl"
lcrSavePath=${test_result_folder}/nrLCR.npy
date=`date +%Y-%m-%d-%H`
logpath=${test_result_folder}
totalbatches=$(( $(( $maxModelsUsed / $batchModelSize )) + $(( $maxModelsUsed % $batchModelSize )) ))


is_adv="False"
#read -p "seedModelPath:" seedModelPath

if [[ ! -d "$logpath" ]];then
    mkdir -p $logpath
fi
for((no_batch=1;no_batch<=${totalbatches};no_batch++))
do
        echo batch:${no_batch}
        model_start_no=$(( $(( $(( no_batch-1 ))*${batchModelSize} ))+1 ))
        echo model_start_no:${model_start_no}
        python  -u $exe_file --dataType ${dataType} \
                         --device  ${device} \
                         --testType ${testType} \
                         --useTrainData ${useTrainData} \
                         --startNo ${model_start_no} \
                         --batchModelSize ${batchModelSize} \
                         --mutatedModelsPath ${mutatedModelsPath} \
                         --testSamplesPath ${testSamplesPath} \
                         --seedModelName ${seedModelName} \
                         --seedModelPath ${seedModelPath} \
                         > $logpath/${no_batch}.log
done
echo "Testing Done!"
python -u $analyze_file --logPath $logpath \
                    --maxModelsUsed $maxModelsUsed \
                    --isAdv $is_adv \
                    --lcrSavePath $lcrSavePath







