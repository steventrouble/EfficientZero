set -ex
export CUDA_DEVICE_ORDER='PCI_BUS_ID'
export CUDA_VISIBLE_DEVICES=0

if [ $# -lt 2 ]; then
  echo "usage: sh test.sh <model> <env>"
fi

python main.py --env "ALE/${2}-v5" --case atari --opr test --seed 15987 --num_gpus 1 --num_cpus 12 --force \
  --test_episodes 32 \
  --load_model \
  --amp_type 'torch_amp' \
  --model_path "${1}" \
  --info 'Test'
