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

## Run it

```
tmux
bash train.sh
```
