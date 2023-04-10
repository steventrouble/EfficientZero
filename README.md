# EfficientZero Remastered
This repo hosts the official remastered version of EfficientZero.

This is the productionized version of the EfficientZero model. Unlike the research version, this model is intended to be used in real-world applications including: Game AI, meta learning, optimization, LLMs, generative models, and more.

__New Features:__

*  A100 training support
*  Full preemption recovery
*  Replay buffer checkpointing
*  Up-to-date dependencies

__Bug fixes:__
*  Fixed GPU <-> CPU memory allocations
*  Fixed several crashes on latest video cards
*  Batch workers auto-restart after certain failures
*  Improved error-handling and messages

__Upcoming features:__
*  Pre-trained models available soon!
*  Instructions on adding new environments.
*  FAQ and forum on production usage.

This project is partially funded by a [stability.ai](https://stability.ai) grant.  
We are not the original authors of the EfficientZero model.

## Environments
EfficientZero requires python3 (>=3.6) and pytorch (>=1.8.0) with the development headers. 

We recommend to use torch amp (`--amp_type torch_amp`) to accelerate training.

### Prerequisites
Before starting training, you need to build the c++/cython style external packages. (GCC version 7.5+ is required.)
```
cd core/ctree
bash make.sh
```

If you're using a brand new graphics card, you'll need to install the latest version of pytorch.
Visit [PyTorch.org: Get started](https://pytorch.org/get-started/locally/) and choose the latest cuda version,
and install it with pip or pipenv. You may need to reinstall pytorch if you've already installed an older version.

E.g. The PyTorch website recommended I run this for my RTX 3080 laptop (Jul 2022).

```
pipenv install --index https://download.pytorch.org/whl/cu116 "torch==1.12.0+cu116" "torchvision==0.13.0+cu116" "torchaudio==0.12.0+cu116"
```

### Installation
To install the (non-driver) dependencies for this, I recommend using pipenv:

```
pipenv --three
pipenv install -r requirements.txt
```

## Usage
### Quick start
* Train: `pipenv run python main.py --env ALE/Breakout-v5 --case atari --opr train --amp_type torch_amp --num_gpus 1 --num_cpus 10 --cpu_actor 1 --gpu_actor 1 --force`
* Test: `pipenv run python main.py --env ALE/Breakout-v5 --case atari --opr test --amp_type torch_amp --num_gpus 1 --load_model --model_path model.p \`
### Bash file
We provide `train.sh` and `test.sh` for training and evaluation.
* Train: 
  * With 4 GPUs (3090): `bash train.sh`
* Test: `pipenv run bash test.sh`

|Required Arguments | Description|
|:-------------|:-------------|
| `--env`                             |Name of the environment|
| `--case {atari}`                    |It's used for switching between different domains(default: atari)|
| `--opr {train,test}`                |select the operation to be performed|
| `--amp_type {torch_amp,none}`       |use torch amp for acceleration|

|Other Arguments | Description|
|:-------------|:-------------|
| `--force`                           |will rewrite the result directory
| `--num_gpus 4`                      |how many GPUs are available
| `--num_cpus 96`                     |how many CPUs are available
| `--cpu_actor 14`                    |how many cpu workers
| `--gpu_actor 20`                    |how many gpu workers
| `--seed 0`                          |the seed
| `--use_priority`                    |use priority in replay buffer sampling
| `--use_max_priority`                |use the max priority for the newly collectted data
| `--amp_type 'torch_amp'`            |use torch amp for acceleration
| `--info 'EZ-V0'`                    |some tags for you experiments
| `--p_mcts_num 8`                    |set the parallel number of envs in self-play 
| `--revisit_policy_search_rate 0.99` |set the rate of reanalyzing policies
| `--use_root_value`                  |use root values in value targets (require more GPU actors)
| `--render`                          |render in evaluation
| `--save_video`                      |save videos for evaluation
 
## Architecture Designs
The architecture of the training pipeline is shown as follows:
![](static/imgs/archi.png)

### Some suggestions
* To use a smaller model, you can choose smaller dim of the projection layers (Eg: 256/64) and the LSTM hidden layer (Eg: 64) in the config. 
* For GPUs with 10G memory instead of 20G memory, you can allocate 0.25 gpu for each GPU maker (`@ray.remote(num_gpus=0.25)`) in `core/reanalyze_worker.py`.

### New environment registration
If you wan to apply EfficientZero to a new environment like `mujoco`. Here are the steps for registration:
1. Follow the directory `config/atari` and create dir for the env at `config/mujoco`.
2. Implement your `MujocoConfig(BaseConfig)` class and implement the models as well as your environment wrapper.
3. Register the case at `main.py`.

## Results 
Evaluation with 32 seeds for 3 different runs (different seeds).
![](static/imgs/total_results.png)

## Citation
If you find this repo useful, please cite our paper:
```
@inproceedings{ye2021mastering,
  title={Mastering Atari Games with Limited Data},
  author={Weirui Ye, and Shaohuai Liu, and Thanard Kurutach, and Pieter Abbeel, and Yang Gao},
  booktitle={NeurIPS},
  year={2021}
}
```

## Contact
If you have any question or want to use the code, please contact ywr20@mails.tsinghua.edu.cn .

## Acknowledgement
We appreciate the following github repos a lot for their valuable code base implementations:

https://github.com/koulanurag/muzero-pytorch

https://github.com/werner-duvaud/muzero-general

https://github.com/pytorch/ELF
