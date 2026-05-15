# Copyright (C) 2024-2025 Souhrud Reddy
# SPDX-License-Identifier: Apache-2.0

#!/bin/bash

# Look for whether there's a supervisor configuration that has the code-server setup
if [ -f /etc/supervisor/conf.d/vscode.conf ] ; then
    sudo supervisorctl start vscode
    # always succeed!
    exit 0
fi

# Check if config file exists and contains the correct bind address, download it if not
if [ ! -f ~/.config/code-server/config.yaml ] || ! grep -q "bind-addr: 0.0.0.0:5899" ~/.config/code-server/config.yaml; then
  echo "Config not found or incorrect!"
  # In CI/non-interactive mode, try to download automatically
  if [ -n "$CI" ] || [ ! -t 1 ]; then
    echo "Downloading..."
    rm ~/.config/code-server/config.yaml 2> /dev/null
    curl -o ~/.config/code-server/config.yaml "https://raw.githubusercontent.com/${GITHUB_REPOSITORY:-${GITHUB_REPO:-}}/main/configs/code-server/config.yaml" 2>/dev/null || {
      # Fallback: use default config
      mkdir -p ~/.config/code-server
      cat > ~/.config/code-server/config.yaml << 'EOF'
bind-addr: 0.0.0.0:5899
auth: password
password: 12345677
cert: false
EOF
    }
  else
    read -p "Config not found or incorrect! Download? (y/n) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
      echo "Downloading..."
      rm ~/.config/code-server/config.yaml 2> /dev/null
      curl -o ~/.config/code-server/config.yaml "https://raw.githubusercontent.com/${GITHUB_REPOSITORY:-${GITHUB_REPO:-}}/main/configs/code-server/config.yaml" 2>/dev/null || {
        # Fallback: use default config
        mkdir -p ~/.config/code-server
        cat > ~/.config/code-server/config.yaml << 'EOF'
bind-addr: 0.0.0.0:5899
auth: password
password: 12345677
cert: false
EOF
      }
    else
      echo "Skipping..."
      exit 1
    fi
  fi
else
  echo "Config found and correct! Skipping..."
fi

# Check if code-server command is available, install it if not
if ! command -v code-server &> /dev/null; then
  # In CI/non-interactive mode, install automatically
  if [ -n "$CI" ] || [ ! -t 1 ]; then
    echo "Code-server not found! Installing..."
    curl -fsSL https://code-server.dev/install.sh | sh
  else
    read -p "Code-server not found! Download? (y/n) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $1 == "--quiet" ]]; then
      echo "Downloading..."
      curl -fsSL https://code-server.dev/install.sh | sh
    else
      echo "Skipping..."
      exit 1
    fi
  fi
else
  echo "Code-server found! Skipping..."
fi

# Create a tmux window called "code-session" and run code-server inside it
tmux kill-session -t "code-session" 2> /dev/null
tmux new-session -d -s "code-session" 
tmux send-keys -t "code-session" 'code-server' Enter
echo "Created code-session!"
