# Install

```sh
sudo apt install -y \
    python3-dev \
    python3-pip \
    python3-venv

python3 -m venv .python &&
source .python/bin/activate &&
pip3 install --upgrade pip &&
pip3 install -r ./requirements.txt
```

# Configure

```sh
make
```

# Run

```sh
bin/run.sh deploy.yml
```

# @TODO

- generate ssh config with array of hosts from .env OR add hosts.yml symlink form ~/.ssh
- add: fail2ban
