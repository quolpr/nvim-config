#!/bin/bash

ln ./.tmux.conf ~/.tmux.conf

mkdir -p ~/.config/alacritty/
ln ./alacritty.toml ~/.config/alacritty/alacritty.toml

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.local/bin/tmux-sessionizer
ln ./tmux-sessionizer ~/.local/bin/tmux-sessionizer

# if command -v curl >/dev/null 2>&1; then
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# else
#   sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# fi
