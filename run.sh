#!/usr/bin/env bash

irc="$HOME/.marslo"
conf='./confs/home'
file="$HOME/.profile"

[[ -d "${irc}"        ]] || mkdir -p "${irc}"
[[ -d "${irc}/bin"    ]] || mkdir -p "${irc}/bin"
[[ -d "${irc}/.alias" ]] || mkdir -p "${irc}/.alias"

function isWSL() {
  if ! uname -r | grep -q "Microsoft"; then echo true; fi
}

# shellcheck disable=SC1083
function macOS() {
  cp -t "${irc}"        "${conf}"/.marslo/.{marslorc,imac,gitalias,gitrc,env,colors,it2colors,bye}
  cp -t "${irc}/.alias" "${conf}"/.marslo/.alias/{imarslo,mac,utils,devops,kubernetes,docker}
}

function unixGeneric() {
  cp -t "${irc}"        "${conf}"/.marslo/.{marslorc,imac,gitalias,gitrc,env,colors,it2colors,bye}
  cp -rt "${irc}"       "${conf}"/.marslo/vimrc.d
}

function bins() {
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/{ifunc,ffunc,ii,ig}.sh
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/{ff,gdoc,fman,ldapsearch}
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/{screenfetch-dev,now,iweather.icon,diff-highlight,git-info}
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/git-*
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/{bash-color,show-color}.sh
  cp -t "${irc}/bin"    "${conf}"/.marslo/bin/{appify,ansi}
}

function encryptFile() {
  binFiles='iweather ifunc.sh now gdoc ldapsearch irt.sh'
  rcFiles='.gitalias'
  aliasFiles='deovps imarslo'
  if [[ 'true' = $(isWSL) ]]; then
    binFiles+=' im.wsl'
    rcFiles+=' .imarslo.wsl .env.wsl'
  else
    binFiles+=' im.sh'
    rcFiles+=' .imarslo .env'
  fi

  while read -r _file; do
    cp -t "${irc}/bin/${_file}" "${conf}"/.marslo/bin/"${_file}".current
  done < <( echo "${binFiles}" | fmt -1 )

  while read -r _file; do
    cp -t "${irc}/${_file}" "${conf}"/.marslo/"${_file}".current
  done < <( echo "${rcFiles}" | fmt -1 )

  while read -r _file; do
    cp -t "${irc}/.alias/${_file}" "${conf}"/.marslo/.alias/"${_file}".current
  done < <( echo "${aliasFiles}" | fmt -1 )
}

function dotConfig() {
  # shellcheck disable=SC2086
  cp -rt $HOME "${conf}"/{.config/nvim,tig/.tigrc,tmux/.tmux.conf,git/.gitconfig,git/.gitignore,git/.gitattributes}
  # shellcheck disable=SC2086
  cp -t $HOME/.inputrc "${conf}"/.inputrc
  # shellcheck disable=SC2086
  cp -t $HOME -r "${conf}"/.{screenrc,iStats,idlerc,fdignore,rgignore}
}

[ -f "$HOME/.gitconfig" ] && cat >> "$HOME/.gitconfig" << EOF
[include]
  path = "${irc}/.gitalias"
EOF

# https://github.com/KittyKatt/screenFetch/issues/692#issuecomment-726631900
if [[ -x /usr/bin/sw_vers ]] && /usr/bin/sw_vers | grep -E '\s*[mM]ac\s*OS\s*X?' >/dev/null; then
  file="$HOME/.bash_profile"
elif [ -f '/etc/os-release' ]; then
  distrab=$(awk -F= '$1=="ID" {print $2;}' /etc/lsb-release)
  [ 'ubuntu' == "${distrab}" ] || [ 'centos' == "${distrab}" ] && file="$HOME/.bashrc"
fi

echo "[ -f \"${irc}\"/.marslorc ] && source \"${irc}\"/.marslorc" >> ~/.bashrc
# shellcheck disable=SC1090
source "${file}"
