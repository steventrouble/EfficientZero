# Deploying on Cloud

I'm using Paperspace to deploy this.

## Set up the machine

Create new Paperspace ML-in-a-box machine. Then run:

```
sudo apt update
sudo apt install python-is-python3 python3-dev
```

## Set up the code

```
git clone https://github.com/steventrouble/EfficientZeroLocal.git
cd EfficientZeroLocal
git checkout new_branch
pip install -r requirements.txt

cd core/ctree
bash make.sh
cd -
```

## Run it

```
tmux
bash train.sh
```
