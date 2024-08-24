#!/bin/bash

ln ./.tmux.conf ~/.tmux.conf

mkdir -p ~/.config/alacritty/
ln ./alacritty.toml ~/.config/alacritty/alacritty.toml

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.local/bin/tmux-sessionizer
ln ./tmux-sessionizer ~/.local/bin/tmux-sessionizer

npm i -g @cspell/cspell-bundled-dicts @cspell/dict-ru_ru/cspell-ext.json @cspell/dict-golang/cspell-ext.json @cspell/dict-software-terms/cspell-ext.json

# if command -v curl >/dev/null 2>&1; then
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# else
#   sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# fi
