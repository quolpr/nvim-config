#!/bin/bash

# brew install delta

ln ./.tmux.conf ~/.tmux.conf
ln ./.gitconfig ~/.gitconfig

mkdir -p ~/.config/alacritty/
ln ./alacritty.toml ~/.config/alacritty/alacritty.toml

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.local/bin
ln ./tmux-sessionizer ~/.local/bin/tmux-sessionizer
ln ./tmux-nvim ~/.local/bin/tmux-nvim
ln ./tmux-zettel ~/.local/bin/tmux-zettel
ln ./explore-code ~/.local/bin/explore-code

npm i -g @cspell/cspell-bundled-dicts @cspell/dict-ru_ru @cspell/dict-golang @cspell/dict-software-terms

# Don't forget to install tmux plugins with prefix + I
# if command -v curl >/dev/null 2>&1; then
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# else
#   sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
# fi
