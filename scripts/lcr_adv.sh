#!/usr/bin/env bash

#############
# Function
#############
exe_file=../lcr_auc/mutated_testing.py
analyze_file=../lcr_auc/lcr_auc_analysis.py



####################
# read parameters
####################

dataType=0
device=-1
useTrainData="False"
batchModelSize=2
maxModelsUsed=100
seedModelName="lenet"
testType="adv"  # normal,adv,wl
mutatedModelsPath="../artifacts_eval/modelMuation/nai0.01/lenet/"
testSamplesPath="../artifacts_eval/adv_samples/mnist/jsma/2021-05-10_18:25:33/"
test_result_folder="../lcr_results/mnist/lenet/nai/1e-2p/jsma/"
seedModelPath=None
nrLcrPath="../lcr_results/mnist/lenet/nai/1e-2p/normal_test/nrLCR.npy"

date=`date +%Y-%m-%d-%H`
logpath=${test_result_folder}
totalbatches=$(( $(( $maxModelsUsed / $batchModelSize )) + $(( $maxModelsUsed % $batchModelSize )) ))
date=`date +%Y-%m-%d-%H`
logpath=${test_result_folder}
totalbatches=$(( $(( $maxModelsUsed / $batchModelSize )) + $(( $maxModelsUsed % $batchModelSize )) ))

is_adv="True"


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
#########################
# analyze the LCR and AUC
#########################

python -u $analyze_file --logPath $logpath \
                        --maxModelsUsed $maxModelsUsed \
                        --isAdv $is_adv \
                        --nrLcrPath $nrLcrPath







