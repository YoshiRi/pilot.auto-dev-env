# Pilot Auto Dev Environment (Minimal Template)

軽量なDocker + Compose構成でAutoware解析環境を起動するための雛形です。


Usage:

```bash
# clone
git clone https://github.com/<your-username>/pilot.auto-dev-env.git
cd pilot.auto-dev-env

# Download image
webauto ci firmware-image pull --project-id <id> --firmware-image-id <image-id> --docker-image <base-image>

# build
./build-image.sh <base-image> (<target-image>)

# run (with GPU support)
./run-dockerimage.sh <your-username>

# enter container with fzf selection
./enter_autoware_container.sh
```

### option

`./run-dockerimage.sh` スクリプトのオプション: `--no-agnocast` を指定すると、`/dev/agnocast` デバイスをコンテナにマウントしません。

### setup

You may follow https://github.com/amadeuszsz/autoware_vscode/blob/main/README.md

```
# Clone this repository
sudo apt -y update && sudo apt -y install git
git clone https://github.com/amadeuszsz/autoware_vscode.git ~/autoware_vscode

# Install dependencies using Ansible (recommended)
sudo apt purge ansible
sudo apt -y update && sudo apt -y install pipx
python3 -m pipx ensurepath
pipx install --include-deps --force "ansible==6.*"
pipx ensurepath && source ~/.bashrc
cd ~/autoware_vscode && ansible-galaxy collection install -f -r "ansible-galaxy-requirements.yaml"
ansible-playbook autoware_vscode.dev_env.setup_host -K
```