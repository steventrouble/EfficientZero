# Deploying on Cloud

I usedambdalabs to deploy this.

## Set up the machine

Create a new machine. Then run:

```
sudo apt update
sudo apt install python-is-python3 python3-dev
```

## Set up the code

```
git clone https://github.com/steventrouble/EfficientZeroLocal.git
cd EfficientZeroLocal
pip install -r requirements.txt

cd core/ctree
bash make.sh
cd -
```

You'll need to tweak the flags (e.g. num_cpus, cpu_actors) in order to take make full use of your system. You can use `ray status` after starting up the script to verify no actors ran out of resources.

## Run it

```
tmux
bash train.sh
```
