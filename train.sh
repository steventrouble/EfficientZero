#!/bin/bash
set -ex
NUM_GPUS="${SLURM_GPUS_ON_NODE:-1}"
NUM_CPUS="${SLURM_CPUS_ON_NODE:-8}"

# To set these values, start the program following these instructions:
#
#  1. Leave CPU actors at 1, and increase GPU actors until GPU full according
#     to `ray satus`
#  2. Increase CPU actors until CPU full.
GPU_ACTORS=140
CPU_ACTORS=40

#py-spy top --subprocesses -- \
python3.8 main.py --env 'ALE/Breakout-v5' --case atari --opr train --force \
  --num_gpus "$NUM_GPUS" --num_cpus "$NUM_CPUS" --gpu_mem 40 \
  --cpu_actor $CPU_ACTORS --gpu_actor $GPU_ACTORS \
  --seed 0 \
  --use_priority \
  --use_max_priority \
  --amp_type 'torch_amp' \
  --info 'EfficientZero-V1' \
  --object_store_mem=1000000000
