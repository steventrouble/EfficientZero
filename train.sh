#!/bin/bash
set -ex
NUM_GPUS="${SLURM_GPUS_ON_NODE:-1}"
NUM_CPUS="$((${SLURM_CPUS_ON_NODE:-8} * 2))"
TASK_NAME="${1:-Asterix}"
RAY_PORT_OFFSET="${2:-0}"
RAY_PORT="$((6379 + ${RAY_PORT_OFFSET}))"
RAY_CS_PORT="$((10001 + ${RAY_PORT_OFFSET}))"
RAY_MIN_WORKER=$((10002 + ${RAY_PORT_OFFSET} *  1000))
RAY_MAX_WORKER=$((10999 + ${RAY_PORT_OFFSET} *  1000))

if [ ! -z "${SLURM_JOB_NODELIST}" ]; then
  ADDRESS="$(hostname):${RAY_PORT}"
else
  ADDRESS="auto"
fi

# To set these values, start the program following these instructions:
#
#  1. Leave CPU actors at 1, and increase GPU actors until GPU full according
#     to `ray satus`
#  2. Increase CPU actors until CPU full.
GPU_ACTORS=25
CPU_ACTORS=15

ray start --head --port=${RAY_PORT} --ray-client-server-port=${RAY_CS_PORT} --min-worker-port=${RAY_MIN_WORKER} --max-worker-port=${RAY_MAX_WORKER} --include-dashboard=false --num-gpus=1 --num-cpus=24

#py-spy top --subprocesses -r 10 -- \
python3.8 main.py --env "ALE/${TASK_NAME}-v5" --case atari --opr train \
  --num_gpus "$NUM_GPUS" --num_cpus "$NUM_CPUS" --gpu_mem 80 \
  --cpu_actor $CPU_ACTORS --gpu_actor $GPU_ACTORS \
  --seed 0 \
  --use_priority \
  --use_max_priority \
  --amp_type 'torch_amp' \
  --info 'EfficientZero-V1' \
  --ray_address "${ADDRESS}" \
  --auto_resume \
  --object_store_mem=1000000000

# Don't forget to run ray stop at the end of any scripts if running these in batch
