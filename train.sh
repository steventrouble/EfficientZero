#!/bin/bash
set -ex
NUM_GPUS="${SLURM_GPUS_ON_NODE:-1}"
NUM_CPUS="$((${SLURM_CPUS_ON_NODE:-8} * 2))"
TASK_NAME="${1:-Asterix}"

# To set these values, start the program following these instructions:
#
#  1. Leave CPU actors at 1, and increase GPU actors until GPU full according
#     to `ray satus`
#  2. Increase CPU actors until CPU full.
GPU_ACTORS=140
CPU_ACTORS=70

#py-spy top --subprocesses -r 10 -- \
python3.8 main.py --env "ALE/${TASK_NAME}-v5" --case atari --opr train \
  --num_gpus "$NUM_GPUS" --num_cpus "$NUM_CPUS" --gpu_mem 40 \
  --cpu_actor $CPU_ACTORS --gpu_actor $GPU_ACTORS \
  --seed 0 \
  --use_priority \
  --use_max_priority \
  --amp_type 'torch_amp' \
  --info 'EfficientZero-V1' \
  --auto_resume \
  --object_store_mem=1000000000
