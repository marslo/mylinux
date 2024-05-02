#!/usr/bin/env bash
# shellcheck source=/dev/null disable=SC1091,SC2015

[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# for :terminal in nvim, avoid scp issue from non-mac system
if [[ 'Darwin' = $(uname) ]]; then
  command -v brew >/dev/null && source "$(brew --prefix git)"/etc/bash_completion.d/git-*.sh \
                             || source "/usr/local/opt/git/etc/bash_completion.d/git-prompt.sh"
else
  [[ -f "/etc/bash_completion.d/git-prompt"         ]] && source "/etc/bash_completion.d/git-prompt"
  [[ -f "/usr/local/libexec/git-core/git-prompt.sh" ]] && source "/usr/local/libexec/git-core/git-prompt.sh"
fi

if [[ 'debian' = $(awk -F '=' '/ID_LIKE/ { print $2 }' /etc/os-release) ]]; then
  export DEBIAN_FRONTEND=noninteractive
fi

function bello() { source ~/.bash_profile; }

# https://brettterpstra.com/2014/07/12/making-cd-in-bash-a-little-better/
# export FIGNORE="Application Scripts:Applications (Parallels):ScrivWatcher:ScriptingAdditions"
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

# vim: tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
