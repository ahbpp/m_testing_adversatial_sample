#!/usr/bin/env bash

#############
# Function
#############
get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}

exe_file=../lcr_auc/mutated_testing.py
analyze_file=../lcr_auc/lcr_auc_analysis.py

echo -e "NOTE: Our experiments are only based on two datasets: mnist and cifar10,\n
         but it is a piece of cake to extend to other datasets only providing a \n
         proper pytorch-style data loader tailored to himself datasets."

echo "To quickly label change rate and auc statistics , we provide a group of default parameters，do you want to quickly start the
program?y/n"
read choice

####################
# read parameters
####################

if test "$choice" = "y"
then
    dataType=0
    device=-1
    useTrainData="False"
    batchModelSize=2
    maxModelsUsed=10
    seedModelName="lenet"
    testType="adv"  # normal,adv,wl
    mutatedModelsPath="../build-in-resource/mutated_models/mnist/lenet/gf/5e-2p/"
    testSamplesPath="../build-in-resource/dataset/mnist/adversarial/jsma/"
    test_result_folder="../lcr_auc-testing-results/mnist/lenet/gf/5e-2p/jsma/"
else
    python $exe_file --help
    echo "Tha above is the description of each paprameter. Please input them one by one."
    echo
    read -p "dataType:" dataType
    read -p "device:"  device
    read -p "testType:" testType
    read -p "useTrainData:" useTrainData
    read -p "batchModelSize:" batchModelSize
    read -p "mutatedModelsPath:" mutatedModelsPath
    read -p "testSamplesPath:" testSamplesPath
    read -p "seedModelName:" seedModelName
    read -p "test_result_folder:" test_result_folder
    read -p "maxModelsUsed:" maxModelsUsed
fi
date=`date +%Y-%m-%d-%H`
logpath=${test_result_folder}-${date}
totalbatches=$(( $(( $maxModelsUsed / $batchModelSize )) + $(( $maxModelsUsed % $batchModelSize )) ))

is_adv="True"
if test "$testType" = "normal"
then
    is_adv="False"
    read -p "Please input the path to save lcr results:" lcrSavePath
    read -p "seedModelPath:" seedModelPath
else
    echo "Please provide the lcr result of normal samples for the auc computinglease test."
    read -p "Do you have the lcr results of normal samples?(y/n)" choice
    if test "$choice" = "y"
    then
        read -p "Path of normal's lcr list:" nrLcrPath
        seedModelPath=None
        #  ../build-in-resource/nr-lcr/ns/5e-2p/nrLCR.npy
    else
        echo "Please gain the lcr lsit of normal samples first.You can achieve this using this script"
        exit
    fi
fi

echo "=======>Please Check Parameters<======="
    if test $dataType = 0
    then
        echo "dataType:" "mnist"
    else
        echo "dataType:" "cifar10"
    fi
    echo "device:" $device
    echo "testType:" $testType
    echo "useTrainData:" $useTrainData
    echo "batchModelSize:" $batchModelSize
    echo "maxModelsUsed:" $maxModelsUsed
    echo "mutatedModelsPath:" $mutatedModelsPath
    echo "testSamplesPath:" $testSamplesPath
    echo "seedModelName:" $seedModelName
    echo "test_result_folder:" $test_result_folder
    echo "The test will be divided into "$totalbatches" batches"
    echo "The logs will be saved in:" $logpath
    echo "is_adv:" $is_adv
    if test "$is_adv" = "True"
    then
        echo "nrLcrPath:" $nrLcrPath
    else
        echo "lcrSavePath:" $lcrSavePath
    fi
echo "<======>Parameters=======>"

echo "Press any key to start mutation process"
echo " CTRL+C break command bash..." # 组合键 CTRL+C 终止命令!
char=`get_char`

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
if test "$is_adv" = "True"
then
    python -u $analyze_file --logPath $logpath \
                        --maxModelsUsed $maxModelsUsed \
                        --isAdv $is_adv \
                        --nrLcrPath $nrLcrPath
else
    python -u $analyze_file --logPath $logpath \
                    --maxModelsUsed $maxModelsUsed \
                    --isAdv $is_adv \
                    --lcrSavePath $lcrSavePath
fi







