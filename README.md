# Adversarial Sample Detection for Deep Neural Network through Model Mutation Testing

Code to the paper "Adversarial Sample Detection for Deep Neural Network through Model Mutation Testing" by Jingyi Wang, Guoliang Dong, Jun Sun, Xinyu Wang, Peixin Zhang in ICSE 2019.

## Requirements

Authors use specific requirements for python 2.7.13  

Authors recommend using the [docker](https://hub.docker.com/r/dgl2019/icse2019-artifacts) image. See [INSTALL](./INSTALL.md) file in this directory to get about its useage.
Original code from github work incorrect. I copy code from docker container. 
Also you can use `requirements.txt` file:
```
pip install requirements.txt
```

## Code Structure

This artifact includes four independent modules.

- Adversarial Sample Generation (attacks) `scripts/craftAdvSamples.sh`
- Mutation Model Generation (lcr_auc) `scripts/generate_mutated_models.sh`
- Label Change Rate(lcr) and AUC over adversarial samples (model_mutation) `scripts/lcr_normal.sh` `scripts/lcr_adv.sh`
Bash scripts run python files.

## Results
### Average LCR table (My results)  
| Dataset | Mutation operator | Mutation rate | Normal samples | Wrong labels | FGSM       | JSMA       | deepfool   |
|---------|-------------------|---------------|----------------|--------------|------------|------------|------------|
|         |                   | 0.01          | 1.51±0.21      | 13.21±1.01   | 47.12±2.35 | 50.17±2.28 | 37.67±2.11 |
| MNIST   | NAI               | 0.03          | 3.13±0.43      | 26.14±1.35   | 51.83±2.51 | 57.56±2.72 | 46.51±2.27 |
|         |                   | 0.05          | 4.1±0.55       | 33.57±1.44   | 54.17±2.61 | 59.13±2.91 | 50.15±2.43 |
|         |                   |               |                |              |            |            |            |
|         |                   | 0.01          | 0.62±0.13      | 16.11±1.21   | 47.92±2.41 | 56.22±2.33 | 41.03±2.21 |
| MNIST   | GF                | 0.03          | 1.51±0.33      | 27.17±1.43   | 51.87±2.59 | 59.94±2.75 | 48.13±2.37 |
|         |                   | 0.05          | 2.73±0.53      | 33.63±1.52   | 54.94±2.72 | 62.41±2.84 | 51.55±2.64 |

#### AUROC Report for MNIST Data (My results)
| attack   | NAI    | GF     |
|----------|--------|--------|
| fgsm     | 0.9705 | 0.9713 |
| jsma     | 0.9951 | 0.9953 |
| deepfool | 0.988  | 0.9883 |

### Average LCR table (Orig paper)  
| Dataset | Mutation operator | Mutation rate | Normal samples | Wrong labels | FGSM       | JSMA       | deepfool   |
|---------|-------------------|---------------|----------------|--------------|------------|------------|------------|
|         |                   | 0.01          | 1.28±0.24      | 14.58±2.64   | 47.56±3.56 | 50.80±2.46 | 37.62±2.83 |
| MNIST   | NAI               | 0.03          | 3.06±0.44      | 27.16±3.11   | 52.12±3.04 | 57.86±2.02 | 46.61±2.43 |
|         |                   | 0.05          | 3.88±0.53      | 32.53±3.15   | 54.54±2.80 | 59.07±1.95 | 50.30±2.24 |
|         |                   |               |                |              |            |            |            |
|         |                   | 0.01          | 0.57±0.30      | 16.75±3.33   | 47.87±3.54 | 56.39±2.14 | 41.07±2.76 |
| MNIST   | GF                | 0.03          | 1.39±0.46      | 27.00±3.40   | 51.87±3.10 | 60.64±1.85 | 48.06±2.41 |
|         |                   | 0.05          | 2.49±0.59      | 33.28±3.28   | 55.02±2.77 | 62.36±1.74 | 51.60±2.19 |

#### AUROC Report for MNIST Data (Orig paper)
| attack   | NAI    | GF     |
|----------|--------|--------|
| fgsm     | 0.9744 | 0.9747 |
| jsma     | 0.9965 | 0.9975 |
| deepfool | 0.9881 | 0.9889 |


The folder **build-in-resource** contains some essential resources,including from original paper: 

- dataset: 
	- the complete MNIST and CIFAR10 dataset
	- the adversarial samples with the attack methods described in original paper
- mutated_model: the mutated models used in the paper
- nr-lcr: the label change rate of normal sampels. 
- pretrained-model: Lenet for mnsit,and GooGleNet for cifar10.

## Code

I slightly change sh scripts for convenience. In `scripts/lcr_normal.sh`, `scripts/lcr_adv.sh` and `scripts/generate_mutated_models.sh` parameters must be changed in sh scripts.

### 1. Enter the Work Directory
To quickly start the experiment, we provide some script for each module in folder "scripts". Just enter the folder and start the experiments.

```
cd scripts/
```
### 2. Adversarial Samples Generation

run the script:

```
./craftAdvSamples.sh
```
You will see the following info:

```
To quickly yield adversarial samples, we provide a default setting for each attack manner.Do you want to perform
an attack with the default settings?y/n
```
You can use the default settings with "y", or specific parameters by yourself with "n". We recommend one to choose "n" firstly to see which parameters are required and the default settings. We demonstrate the useage of default mode here.

Back to the useage example, input "y" to continue.

```
# you need choose which dataset you want to attack. Here mnist is selected.
dataType ( [0] mnist; [1] cifar10): 0
# Then,choose which attac manner you want to use. Here fgsm is selected.
attackType:fgsm
```
If everything goes well, you will see the following info after typing "Enter":

```
=======>Please Check Parameters<=======
modelName: lenet
modelPath: ../build-in-resource/pretrained-model/lenet.pkl
dataType: 0
sourceDataPath: ../build-in-resource/dataset/mnist/raw
attackType: fgsm
attackParameters: 0.35,true
savePath: ../artifacts_eval/adv_samples/mnist/fgsm
device: -1
<======>Parameters=======>
```
If you do not need to alter the settings, then press any key to continue and you will see a log info immediately:

```
Crafting Adversarial Samples....
```
Note, it maybe take some time to generate the adversarail samples for some specific attacks.

If successful, the following info will be printed on the screen finally.

```
successful samples 2054
Done!
icse19-eval-attack-fgsm: rename 125, remove 40,success 1889
Adversarial samples are saved in ../artifacts_eval/adv_samples/mnist/fgsm/2019-01-13_03:48:45
DONE!
```

### 3. Mutation Model Generation
Run the script:

```
./generate_mutated_models.sh
```

You will see the following info:
```
2019-01-13 13:28:47,651 - INFO - data type:mnist
2019-01-13 13:28:47,655 - INFO - >>>>>>>>>>>>Start-new-experiment>>>>>>>>>>>>>>>>
2019-01-13 13:28:48,275 - INFO - orginal model acc=0.9829
2019-01-13 13:28:48,275 - INFO - acc_threshold:88.0%
2019-01-13 13:28:48,275 - INFO - seed_md_name:lenet,op_type:GF,ration:0.001,acc_tolerant:0.9,num_mutated:10
2019-01-13 13:28:48,305 - INFO - 61/61706 weights to be fuzzed
2019-01-13 13:28:48,885 - INFO - Mutated model: accurate 0.9827
2019-01-13 13:28:48,886 - INFO - Progress:1/10
2019-01-13 13:28:48,892 - INFO - 61/61706 weights to be fuzzed
2019-01-13 13:28:49,493 - INFO - Mutated model: accurate 0.9832
...
```
When finished, the last line in the screen is expected be:
```
The mutated models are stored in ../artifacts_eval/modelMuation/nai0.001/lenet
```

### 4. Label change rate and auc statistics
Run the script to estimate LCR for normal data:

```
./lcr_normal.sh
```
If everything goes well, the expected input is:

```
batch:1
model_start_no:1
batch:2
model_start_no:3
batch:3
model_start_no:5
batch:4
model_start_no:7
batch:5
model_start_no:9
Testing Done!
Total Samples Used:1000,avg_lcr:0.0151,std:0.0260,confidence(95%):0.0016,confidence(98%):0.0019,confidence(99%):0.0021
```
Run the script to estimate LCR for adversarial data:

```
./lcr_adv.sh
```

## Reference
- [original paper](https://arxiv.org/pdf/1812.05793v2.pdf)
- [carlini/nn_robust_attacks](https://github.com/carlini/nn_robust_attacks)
- [DeepFool](https://github.com/paulasquin/DeepFool)













 
