#!/usr/bin/env bash
# shellcheck disable=SC1090
#=============================================================================
#     FileName : run.sh
#       Author : marslo.jiao@gmail.com
#      Created : 2021-08-11 22:13:38
#   LastChange : 2024-01-17 00:37:53
#=============================================================================

# shellcheck disable=SC1091
source ./dotfils/.marslo/bin/bash-color.sh

irc="$HOME/.marslo"
dotfolder='./dotfiles'
CP="$(type -P cp)"
timestampe="$(date +%y%m%d%H%M%S)"

function isWSL() { if ! uname -r | grep -q "Microsoft"; then echo true; fi; }
function isMac() { [[ 'Darwin' = $(uname) ]] && echo true; }

function message() {
  [[ 2 != "$#" ]] && echo -e "$(c Rs)ERROR: must provide two parameters to message function$(s). Exit .." && exit 1
  local type="$1"
  local msg="$2"
  if [[ 'warn' = "${type}" ]]; then
    echo -e "$(c Rs)>> $(c Rsn)WARNING$(c) : $(c Rs)${msg}. SKIP ..$(c)"
  elif [[ 'info' = "${type}" ]]; then
    echo -e "$(c Bs)>> INFO   $(c) : ${msg}"
  fi
}

# shellcheck disable=SC2086
function doCopy() {
  [[ 2 -gt "$#" ]] && echo -e "$(c Rs)ERROR: \`message\` function requires at least 2 parameters!$(s). Exit .." && exit 1
  local target="$1"
  local sources=${*: 2}
  local opt='-t'

  while read -r source; do

    if [[ -e "${source}" ]]; then
      name="$(basename ${source})"
      if [[ -e "${target}/${name}" ]]; then
        message 'warn' "target: '${target}/${name}' already EXISTS. Copy manually."
      else
        message 'info' "copy ${source} to ${target}"
        [[ -d "${source}" ]] && opt='-r -t'
        [[ -d "${target}" ]] || mkdir -p "${target}"
        eval "${CP} ${opt} '${target}' '${source}'"
      fi
    else
      message 'warn' "source: '${source}' CANNOT be found"
    fi

  done < <(echo "${sources}" | fmt -1)
}

function backup() {
  [[ -d "${irc}"        ]] && mv "${irc}"{,."${timestampe}"}
  [[ -d "${irc}/bin"    ]] && mv "${irc}/bin"{,."${timestampe}"}
  [[ -d "${irc}/.alias" ]] && mv "${irc}/.alias"{,."${timestampe}"}
  [[ -d "$HOME/.docker" ]] && mv "$HOME/.docker"{,."${timestampe}"}
  [[ -d "$HOME/.config" ]] && mv "$HOME/.config"{,."${timestampe}"}
}

function createDir() {
  [[ -d "${irc}"        ]] || mkdir -p "${irc}"
  [[ -d "${irc}/bin"    ]] || mkdir -p "${irc}/bin"
  [[ -d "${irc}/.alias" ]] || mkdir -p "${irc}/.alias"
  [[ -d "$HOME/.docker" ]] || mkdir -p "$HOME/.docker"
  [[ -d "$HOME/.config" ]] || mkdir -p "$HOME/.config"
}

function dotConfig() {
  if [[ ! -d "$HOME"/.config/nvim ]]; then
    doCopy "$HOME/.config" "${dotfolder}"/.config/nvim
  fi
  doCopy "$HOME"         "${dotfolder}"/.idlerc
  doCopy "$HOME"         "${dotfolder}"/.{gitconfig,gitignore,gitattributes,fdignore,rgignore,ctags}
  doCopy "$HOME"         "${dotfolder}"/.{screenrc.wgetrc,tigrc,curlrc,inputrc}
  doCopy "$HOME/.docker" "${dotfolder}"/.docker/daemon.json
}

function generic() {
  doCopy "${irc}"        "${dotfolder}"/.marslo/vimrc.d
  doCopy "${irc}"        "${dotfolder}"/.marslo/.{env,gitalias,gitrc,colors,bye}
  doCopy "${irc}"        "${dotfolder}"/.marslo/.{it2colors,it2colors.css,.it2colorname}
  doCopy "${irc}/.alias" "${dotfolder}"/.marslo/.alias/{utils,kubernetes,docker}
}

function bins() {
  doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/{ifunc,ffunc,ii,ig,im}.sh
  doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/{ff,gdoc,fman,ldapsearch}
  doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/{screenfetch-dev,now,iweather.icon,diff-highlight,git-info,ansi}
  doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/git-*
  doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/{bash-color,show-color}.sh
}

function completion() {
  mkdir -p "${irc}/completion"
  ln -sf "$(realpath ./dotfils/.marslo/.completion)" "${irc}/completion"
}

function special() {
  if [[ true = $(isMac) ]]; then
    doCopy "${irc}"        "${dotfolder}"/.marslo/.imac
    doCopy "${irc}/.alias" "${dotfolder}"/.marslo/.alias/mac
    doCopy "${irc}/bin"    "${dotfolder}"/.marslo/bin/appify
  elif [[ true = $(isWSL) ]]; then
    doCopy "${irc}"        "${dotfolder}"/.marslo/.iwsl
  fi
}

# shellcheck disable=SC2086
function encryptFiles() {
  binFiles='iweather ifunc.sh now gdoc ldapsearch irt.sh'
  rcFiles='.gitalias'
  aliasFiles='deovps imarslo'
  homeRC='.bash_profile .profile'
  confFiles='.pip/pip.config .docker/config.json .ssh/config'

  while read -r _file; do
    dir=$(dirname "${_file}")
    [[ -d "$HOME/${dir}" ]] || mkdir -p "$HOME/${dir}"
    doCopy "$HOME"/"${_file}" "${dotfolder}/${_file}"
  done < <( echo "${confFiles}" | fmt -1 )

  while read -r _file; do
    doCopy "$HOME/${_file}" "${dotfolder}"/"${_file}".current
  done < <( echo "${homeRC}" | fmt -1 )

  while read -r _file; do
    doCopy "${irc}/${_file}" "${dotfolder}"/.marslo/"${_file}".current
  done < <( echo "${rcFiles}" | fmt -1 )

  while read -r _file; do
    doCopy "${irc}/bin/${_file}" "${dotfolder}"/.marslo/bin/"${_file}".current
  done < <( echo "${binFiles}" | fmt -1 )

  while read -r _file; do
    doCopy "${irc}/.alias/${_file}" "${dotfolder}"/.marslo/.alias/"${_file}".current
  done < <( echo "${aliasFiles}" | fmt -1 )

  echo -e "$(c Ms)>> decrypt following files manually $(c) :"
  echo -e "$(c Msi)$ command vim $(echo ${confFiles}  | fmt -1 | xargs -I{} bash -c "echo $HOME/{}"         | xargs )$(c)"
  echo -e "$(c Msi)$ command vim $(echo ${homeRC}     | fmt -1 | xargs -I{} bash -c "echo $HOME/{}"         | xargs )$(c)"
  echo -e "$(c Msi)$ command vim $(echo ${rcFiles}    | fmt -1 | xargs -I{} bash -c "echo ${irc}/{}"        | xargs )$(c)"
  echo -e "$(c Msi)$ command vim $(echo ${binFiles}   | fmt -1 | xargs -I{} bash -c "echo ${irc}/bin/{}"    | xargs )$(c)"
  echo -e "$(c Msi)$ command vim $(echo ${aliasFiles} | fmt -1 | xargs -I{} bash -c "echo ${irc}/.alias/{}" | xargs )$(c)"
}

while true; do
  read -p "Do you want backup folders to avoid replaced [Y/N]" yn
  case $yn in
      [Yy]* ) backit=1                                  ;;
      [Nn]* ) backit=0                                  ;;
          * ) echo "only allows Y or N, ctrl-c to exit" ;;
  esac
done

[[ 1 = "${backit}"   ]] && backup && createDir
[[ true = "$(isWSL)" ]] && mrc='.marslorc.wsl' || mrc='.marslorc'

dotConfig
generic
bins
special
encryptFiles

if [[ -f "$HOME/.bashrc" ]]; then
  echo "[ -f \"${irc}/${mrc}\"] && source \"${irc}/${mrc}\"" >> ~/.bashrc
else
  doCopy "$HOME" "${dotfolder}"/.bashrc
  [[ true = "$(isWSL)" ]] && sed -r 's/\.marslorc/\.marslorc.wsl/g' -i ~/.bashrc
fi
source ~/.bashrc

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh:foldmethod=marker:foldmarker=#\ **************************************************************/,#\ /**************************************************************
