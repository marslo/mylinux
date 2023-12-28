#!/usr/bin/env bash
# shellcheck disable=SC1078,SC1079,SC2086
# =============================================================================
#    FileName : ifunc.sh
#      Author : marslo.jiao@gmail.com
#     Created : 2012
#  LastChange : 2023-12-27 16:46:54
# =============================================================================

function take() { mkdir -p "$1" && cd "$1" || return; }
function cdls() { cd "$1" && ls; }
function cdla() { cd "$1" && la; }
function chmv() { sudo mv "$1" "$2"; sudo chown -R "$(whoami)":"$(whoami)" "$2"; }
function chcp() { sudo cp -r "$1" "$2"; sudo chown -R "$(whoami)":"$(whoami)" "$2"; }
function cha() { sudo chown -R "$(whoami)":"$(whoami)" "$1"; }
function getperm() { find "$1" -printf '%m\t%u\t%g\t%p\n'; }
function rdiff() { rsync -rv --size-only --dry-run "$1" "$2"; }
function rget() { route -nv get "$@"; }
function forget() { history -d $(( $(history | tail -n 1 | ${GREP} -oP '^ \d+') - 1 )); }
function dir755() { find . -type d -perm 0777 \( -not -path "*.git" -a -not -path "*.git/*" \) -exec sudo chmod 755 {} \; -print ; }
function file644() { find . -type f -perm 0777 \( -not -path "*.git" -a -not -path "*.git/*" \) -exec sudo chmod 644 {} \; -print; }
function convert2av() { ffmpeg -i "$1" -i "$2" -c copy -map 0:0 -map 1:0 -shortest -strict -2 "$3"; }
function zh() { zipinfo "$1" | head; }
function cleanview() { rm -rf ~/.vim/view/*; }
# https://unix.stackexchange.com/a/269085/29178
function color() { for c; do printf '\e[48;5;%dm%03d ' "$c" "$c"; done; printf '\e[0m \n'; }

# /**************************************************************
#        _   _ _ _ _
#       | | (_) (_) |
#  _   _| |_ _| |_| |_ _   _
# | | | | __| | | | __| | | |
# | |_| | |_| | | | |_| |_| |
#  \__,_|\__|_|_|_|\__|\__, |
#                       __/ |
#                      |___/
# **************************************************************/

# inspired from http://www.earthinfo.org/linux-disk-usage-sorted-by-size-and-human-readable/
function udfs {
  v='*'
  # shellcheck disable=SC2124
  [ 1 -le $# ] && v="$@"
  du -sk ${v} | sort -nr | while read -r size fname; do
    for unit in k M G T P E Z Y; do
      if [ "$size" -lt 1024 ]; then
        echo -e "${size}${unit}\\t${fname}";
        break;
      fi;
      size=$((size/1024));
    done;
  done
}

function mdiff() {
  echo -e " [${1##*/}]\\t\\t\\t\\t\\t\\t\\t[${2##*/}]"
  diff -y --suppress-common-lines "$1" "$2"
}

function dir() {
  [[ 0 -eq $# ]] && _p='.' || _p="$*"
  find . -iname "${_p}" -print0 | xargs -r0 ${LS} -altr | awk '{print; total += $5}; END {print "total size: ", total}';
}

function dir-h() {
  [[ 0 -eq $# ]] && _p='.' || _p="$*"
  find . -iname "${_p}" -exec ${LS} -lthrNF --color=always {} \;
  find . -iname "${_p}" -print0 | xargs -r0 du -csh| tail -n 1
}

ibtoc() {
  path=${*:-}
  if [ 0 -eq $# ]; then
    # shellcheck disable=SC2124
    path="${MYWORKSPACE}/tools/git/marslo/mbook/docs"
    xargs doctoc --github \
                 --notitle \
                 --maxlevel 3 >/dev/null \
           < <( fd . "${path}" --type f --extension md --exclude SUMMARY.md --exclude README.md )
  else
    doctoc --github --maxlevel 3 "${path}"
  fi
}

# /**************************************************************
#            _
#           | |
#   ___ ___ | | ___  _ __ ___
#  / __/ _ \| |/ _ \| '__/ __|
# | (_| (_) | | (_) | |  \__ \
#  \___\___/|_|\___/|_|  |___/
#
# references:
#  - [WAOW! Complete explanations](https://stackoverflow.com/a/28938235/101831)
#  - [coloring functions](https://gist.github.com/inexorabletash/9122583)
#  - [ppo/bash-colors](https://github.com/ppo/bash-colors/tree/master)
# **************************************************************/

function 256colors() {
  for i in {0..255}; do
    echo -e "\e[38;05;${i}m█${i}";       # ctrl+v -> u258c ( left half block ); u2588 ( full block )
  done | column -c 180 -s ' ';
  echo -e "\e[m"
}

function 256color() {
  declare c="38"
  [[ '-b' = "$1" ]] && c="48"
  [[ '-a' = "$1" ]] && c="38 48"

  for fgbg in ${c} ; do                    # foreground / background
    for color in {0..255} ; do             # colors
      # display the color
      printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
      # display 6 colors per lines
      if [ $(( (color + 1) % 6 )) == 4 ] ; then
        echo                               # new line
      fi
    done
    echo                                   # new line
  done
}

function 256colorsAll() {
  for clbg in {40..47} {100..107} 49 ; do  # background
    for clfg in {30..37} {90..97} 39 ; do  # foreground
      for attr in 0 1 2 4 5 7 ; do         # formatting
        # print the result
        echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
      done
      echo                                 # new line
    done
  done
}

# https://stackoverflow.com/a/69648792/2940319
# usage:
#   - `showcolors fg`
#   - `showcolors bg`
# ansi --color-codes
function showcolors() {
  local row col blockrow blockcol red green blue
  local showcolor=_showcolor_${1:-fg}
  local white="\033[1;37m"
  local reset="\033[0m"

  echo -e "set foreground color: \\\\033[38;5;${white}NNN${reset}m"
  echo -e "set background color: \\\\033[48;5;${white}NNN${reset}m"
  echo -e "reset color & style:  \\\\033[0m"
  echo

  echo 16 standard color codes:
  for row in {0..1}; do
    for col in {0..7}; do
      $showcolor $(( row*8 + col )) $row
    done
    echo
  done
  echo

  echo 6·6·6 RGB color codes:
  for blockrow in {0..2}; do
    for red in {0..5}; do
      for blockcol in {0..1}; do
        green=$(( blockrow*2 + blockcol ))
        for blue in {0..5}; do
          $showcolor $(( red*36 + green*6 + blue + 16 )) $green
        done
        echo -n "  "
      done
      echo
    done
    echo
  done

  echo 24 grayscale color codes:
  for row in {0..1}; do
    for col in {0..11}; do
      $showcolor $(( row*12 + col + 232 )) $row
    done
    echo
  done
  echo
}

function _showcolor_fg() {
  # shellcheck disable=SC2155
  local code=$( printf %03d $1 )
  echo -ne "\033[38;5;${code}m"
  echo -nE " $code "
  echo -ne "\033[0m"
}

function _showcolor_bg() {
  if (( $2 % 2 == 0 )); then
    echo -ne "\033[1;37m"
  else
    echo -ne "\033[0;30m"
  fi
  # shellcheck disable=SC2155
  local code=$( printf %03d $1 )
  echo -ne "\033[48;5;${code}m"
  echo -nE " $code "
  echo -ne "\033[0m"
}

# /**************************************************************
#  __      __
#  / _|    / _|
# | |_ ___| |_
# |  _|_  /  _|
# | |  / /| |
# |_| /___|_|
#
# brew install fzf
# **************************************************************/

## preview contents via `$ cd **<tab>`: https://pragmaticpineapple.com/four-useful-fzf-tricks-for-your-terminal/
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd ) fzf "$@" --preview 'tree -C {} | head -200' ;;
     * ) fzf "$@"                                    ;;
  esac
}

# smart copy - using `fzf` to list files and copy the selected file
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description :
#   - if `copy` without parameter, then list file via `fzf` and copy the content
#     - "${COPY}"
#       - `pbcopy` in osx
#       - `/mnt/c/Windows/System32/clip.exe` in wsl
#   - otherwise copy the content of parameter `$1` via `pbcopy` or `clip.exe`
# shellcheck disable=SC2317
function copy() {                          # smart copy
  [[ -z "${COPY}" ]] && echo -e "$(c Rs)ERROR: 'copy' function NOT support :$(c) $(c Ri)$(uanme -v)$(c)$(c Rs). EXIT..$(c)"; exit 0
  if [[ 0 -eq $# ]]; then
    "${COPY}" < <(fzf --cycle --exit-0)
  else
    "${COPY}" < "$1"
  fi
}

# smart cat - using bat by default for cat content, respect bat options
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description :
#   - if `bat` without  paramter, then search file via `fzf` and shows via `bat`
#   - if `bat` with 1   paramter, and `$1` is directory, then search file via `fzf` from `$1` and shows via `bat`
#   - if `bat` with 1st paramter is `-c`, then call default `cat` with rest of paramters
#   - otherwise respect `bat` options, and shows via `bat`
function cat() {                           # smart cat
  local fdOpt='--type f --hidden --follow --exclude .git --exclude node_modules'
  if ! uname -r | grep -q "Microsoft"; then fdOpt+=' --exec-batch ls -t'; fi
  if [[ 0 -eq $# ]]; then
    # shellcheck disable=SC2046
    bat --theme='gruvbox-dark' $(fd . ${fdOpt} | fzf --multi --cycle --exit-0)
  elif [[ '-c' = "$1" ]]; then
    $(type -P cat) "${@:2}"
  elif [[ 1 -eq $# ]] && [[ -d $1 ]]; then
    local target=$1;
    fd . "${target}" ${fdOpt} |
      fzf --multi --cycle --bind="enter:become(bat --theme='gruvbox-dark' {+})" ;
  else
    bat --theme='gruvbox-dark' "${@:1:$#-1}" "${@: -1}"
  fi
}

# magic vim - fzf list in recent modified order
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description :
#   - if `vim` commands without paramters, then call fzf and using vim to open selected file
#   - if `vim` commands with    paramters
#       - if single paramters and parameters is directlry, then call fzf in target directory and using vim to open selected file
#       - otherwise call regular vim to open file(s)
#   - to respect fzf options by: `type -t _fzf_opts_completion >/dev/null 2>&1 && complete -F _fzf_opts_completion -o bashdefault -o default vim`
function vim() {                           # magic vim - fzf list in most recent modified order
  local option
  local target
  local fdOpt="--type f --hidden --follow --unrestricted --ignore-file $HOME/.fdignore"
  if ! uname -r | grep -q "Microsoft"; then fdOpt+=' --exec-batch ls -t'; fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help ) option+="$1 "   ; shift   ;;
          -* ) option+="$1 $2 "; shift 2 ;;
           * ) break                     ;;
    esac
  done
  option+="--multi --cycle"

  if [[ ! "${option}" =~ '--help' ]] && [[ 0 -eq $# ]]; then
    fd . ${fdOpt} | fzf ${option//--help\ /} --bind="enter:become($(type -P vim) {+})"
  elif [[ 1 -eq $# ]] && [[ -d $1 ]]; then
    [[ '.' = "${1}" ]] && target="${1}" || target=". ${1}"
    fd ${target} ${fdOpt} | fzf ${option//--help\ /} --bind="enter:become($(type -P vim) {+})"
  else
    # shellcheck disable=SC2068
    $(type -P vim) -u $HOME/.vimrc ${option//--multi\ --cycle/} $@
  fi
}

# v - open files in ~/.vim_mru_files       # https://github.com/junegunn/fzf/wiki/Examples#v
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description : list 10 most recently used files via fzf, and open by regular vim
function v() {                             # v - open files in ~/.vim_mru_files
  local files
  files=$( grep --color=none -v '^#' ~/.vim_mru_files |
           while read -r line; do [ -f "${line/\~/$HOME}" ] && echo "$line"; done |
           fzf-tmux -d -m -q "$*" -1
         ) &&
  vim ${files//\~/$HOME}
}

function fzfInPath() {                   # return file name via fzf in particular folder
  local fdOpt="--type f --hidden --follow --unrestricted --ignore-file $HOME/.fdignore"
  if ! uname -r | grep -q 'Microsoft'; then fdOpt+=' --exec-batch ls -t'; fi
  [[ '.' = "${1}" ]] && path="${1}" || path=". ${1}"
  eval "fd ${path} ${fdOpt} | fzf --cycle --multi ${*:2} --header 'filter in ${1} :'"
}

# magic vimdiff - using fzf list in recent modified order
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description :
#   - if any of paramters is directory, then get file path via fzf in target path first
#   - if `vimdiff` commands without parameter , then compare files in `.` and `~/.marslo`
#   - if `vimdiff` commands with 1  parameter , then compare files in current path and `$1`
#   - if `vimdiff` commands with 2  parameters, then compare files in `$1` and `$2`
#   - otherwise ( if more than 2 parameters )  , then compare files in `${*: -2:1}` and `${*: -1}` with paramters of `${*: 1:$#-2}`
#   - to respect fzf options by: `type -t _fzf_opts_completion >/dev/null 2>&1 && complete -F _fzf_opts_completion -o bashdefault -o default vimdiff`
function vimdiff() {                       # smart vimdiff
  local lFile
  local rFile
  local option
  local var

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help ) option+="$1 "   ; shift   ;;
          -* ) option+="$1 $2 "; shift 2 ;;
           * ) break                     ;;
    esac
  done

  if [[ 0 -eq $# ]]; then
    lFile=$(fzfInPath '.' "${option}")
    # shellcheck disable=SC2154
    rFile=$(fzfInPath "${iRCHOME}" "${option}")
  elif [[ 1 -eq $# ]]; then
    lFile=$(fzfInPath '.' "${option}")
    [[ -d "$1" ]] && rFile=$(fzfInPath "$1" "${option}") || rFile="$1"
  elif [[ 2 -eq $# ]]; then
    [[ -d "$1" ]] && lFile=$(fzfInPath "$1" "${option}") || lFile="$1"
    [[ -d "$2" ]] && rFile=$(fzfInPath "$2" "${option}") || rFile="$2"
  else
    var="${*: 1:$#-2}"
    [[ -d "${*: -2:1}" ]] && lFile=$(fzfInPath "${*: -2:1}") || lFile="${*: -2:1}"
    [[ -d "${*: -1}"   ]] && rFile=$(fzfInPath "${*: -1}")   || rFile="${*: -1}"
  fi

  [[ -f "${lFile}" ]] && [[ -f "${rFile}" ]] && $(type -P vim) -d ${var} "${lFile}" "${rFile}"
}

# vd - open vimdiff loaded files from ~/.vim_mru_files
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description : list 10 most recently used files via fzf, and open by vimdiff
#   - if `vd` commands without parameter, list 10 most recently used files via fzf, and open selected files by vimdiff
#   - if `vd` commands with `-a` ( [q]uiet ) parameter, list 10 most recently used files via fzf and automatic select top 2, and open selected files by vimdiff
function vd() {                            # vd - open vimdiff loaded files from ~/.vim_mru_files
  [[ 1 -eq $# ]] && [[ '-q' = "$1" ]] && opt='--bind start:select+down+select' || opt=''
  # shellcheck disable=SC2046
  files=$( grep --color=none -v '^#' ~/.vim_mru_files |
           xargs -d'\n' -I_ bash -c "sed 's:\~:$HOME:' <<< _" |
           fzf --multi 3 --sync --cycle --reverse ${opt}
         ) &&
  vimdiff $(xargs <<< "${files}")
}

function cdp() {                           # cdp - [c][d] to selected [p]arent directory
  # shellcheck disable=SC2034,SC2316
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      # shellcheck disable=SC2046
      get_parent_dirs $(dirname "$1")
    fi
  }
  # shellcheck disable=SC2155,SC2046
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR" || return
}

function cdf() {                           # [c][d] into the directory of the selected [f]ile
  local file
  local dir
  # shellcheck disable=SC2164
  file=$(fzf --multi --query "$1") && dir=$(dirname "${file}") && cd "${dir}"
}

function fif() {                           # [f]ind-[i]n-[f]ile
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  $(type -P rg) --files-with-matches --no-messages --hidden --follow --smart-case "$1" |
  fzf --bind 'ctrl-p:preview-up,ctrl-n:preview-down' \
      --bind "enter:become($(type -P vim) {+})" \
      --header 'CTRL-N/CTRL-P or CTRL-↑/CTRL-↓ to view contents' \
      --preview "bat --color=always --style=plain {} |
                 rg --no-line-number --colors 'match:bg:yellow' --ignore-case --pretty --context 10 \"$1\" ||
                 rg --no-line-number --ignore-case --pretty --context 10 \"$1\" {} \
                "
}

function lsps() {                          # [l]i[s]t [p]roces[s]
  (date; ps -ef) |
  fzf --bind='ctrl-r:reload(date; ps -ef)' \
      --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
      --preview='echo {}' --preview-window=down,3,wrap \
      --layout=reverse --height=80% |
  awk '{print $2}'
}

function killps() {                        # [kill] [p]roces[s]
  (date; ps -ef) |
  fzf --bind='ctrl-r:reload(date; ps -ef)' \
      --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
      --preview='echo {}' --preview-window=down,3,wrap \
      --layout=reverse --height=80% |
  awk '{print $2}' |
  xargs kill -9
}

# kns - kubectl set default namesapce
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description : using `fzf` to list all available namespaces and use the selected namespace as default
# [k]ubectl [n]ame[s]pace
function kns() {                           # [k]ubectl [n]ame[s]pace
  echo 'sms-fw-devops-ci sfw-vega sfw-alpine sfw-stellaris sfw-ste sfw-titania' |
        fmt -1 |
        fzf -1 -0 --no-sort --no-multi --prompt='namespace> ' |
        xargs -i bash -c "echo -e \"\033[1;33m~~> {}\\033[0m\";
                          kubectl config set-context --current --namespace {};
                          kubecolor config get-contexts;
                         "
}

# eclr - environment variable clear, support multiple select
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description : list all environment variable via `fzf`, and unset for selected items
function eclr() {                          # [e]nvironment variable [c][l]ea[r]
  while read -r _env; do
    echo -e "$(c Ys)>> unset ${_env}$(c)\n$(c Wdi).. $(eval echo \$${_env})$(c)"
    unset "${_env}"
  done < <( echo 'LDFLAGS CFLAGS CPPFLAGS PKG_CONFIG_PATH LIBRARY_PATH' |
                  fmt -1 |
                  fzf -1 --exit-0 \
                         --no-sort \
                         --multi \
                         --cycle \
                         --prompt 'env> ' \
                         --header 'TAB/SHIFT-TAB to select multiple items, CTRL-D to deselect-all, CTRL-S to select-all'
          )
  # echo -e "\n$(c Wdi)[TIP]>> to list all env via $(c)$(c Wdiu)\$ env | sed -rn 's/^([a-zA-Z0-9]+)=.*$/\1/p'$(c)"
}

# penv - print environment variable, support multiple select
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description : list all environment variable via `fzf`, and print values for selected items
#   - to copy via `-c`
#     - "${COPY}"
#       - `pbcopy` in osx
#       - `/mnt/c/Windows/System32/clip.exe` in wsl
#   - to respect fzf options via `type -t _fzf_opts_completion >/dev/null 2>&1 && complete -F _fzf_opts_completion -o bashdefault -o default penv`
function penv() {                          # [p]rint [e]nvironment variable
  local option
  local -a array
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -c ) option+="$1 "   ; shift   ;;
      -* ) option+="$1 $2 "; shift 2 ;;
       * ) break                     ;;
    esac
  done

  option+='-1 --exit-0 --sort --multi --cycle'
  while read -r _env; do
    echo -e "$(c Ys)>> ${_env}$(c)\n$(c Wi).. $(eval echo \$${_env})$(c)"
    array+=( "${_env}=$(eval echo \$${_env})" )
  done < <( env |
            sed -r 's/^([a-zA-Z0-9_-]+)=.*$/\1/' |
            fzf ${option//-c\ /} \
                --prompt 'env> ' \
                --header 'TAB/SHIFT-TAB to select multiple items, CTRL-D to deselect-all, CTRL-S to select-all'
          )
  [[ "${option}" == *-c\ * ]] && [[ -n "${COPY}" ]] && "${COPY}" < <( printf '%s\n' "${array[@]}" | head -c-1 )
}

# imgview - fzf list and preview images
# @author      : marslo
# @source      : https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/ifunc.sh
# @description :
#   - to respect fzf options by: `type -t _fzf_opts_completion >/dev/null 2>&1 && complete -F _fzf_opts_completion -o bashdefault -o default imgview`
#   - disable `gif` due to imgcat performance issue
# shellcheck disable=SC2215
function imgview() {                       # view image via [imgcat](https://github.com/eddieantonio/imgcat)
  fd --unrestricted --type f --exclude .git --exclude node_modules '^*\.(png|jpeg|jpg|xpm|bmp)$' |
  fzf "$@" --height 100% \
           --preview "imgcat -W \$FZF_PREVIEW_COLUMNS -H \$FZF_PREVIEW_LINES {}" \
           --bind 'ctrl-y:execute-silent(echo -n {+} | pbcopy)+abort' \
           --header 'Press CTRL-Y to copy name into clipboard' \
           --preview-window 'down:80%:nowrap' \
           --exit-0 \
  >/dev/null || true
}

# fman - fzf list and preview for manpage:
# @source      : https://github.com/junegunn/fzf/wiki/examples#fzf-man-pages-widget-for-zsh
# @description :
#   - CTRL-N/CTRL-P or SHIFT-↑/↓ for view preview content
#   - ENTER/Q for toggle maximize/normal preview window
#   - CTRL+O  for toggle tldr in preview window
#   - CTRL+I  for toggle man in preview window
#   - to respect fzf options by: `type -t _fzf_opts_completion >/dev/null 2>&1 && complete -F _fzf_opts_completion -o bashdefault -o default fman`
# shellcheck disable=SC2046
function fman() {
  local option
  local batman="man {1} | col -bx | bat --language=man --plain --color always --theme='gruvbox-dark'"

  while [[ $# -gt 0 ]]; do
    case "$1" in
          -* ) option+="$1 $2 "; shift 2 ;;
           * ) break                     ;;
    esac
  done

  man -k . |
  sort -u |
  sed -r 's/(\(.+\))//g' |
  grep -v -E '::' |
  awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue $2;} 1' |
  fzf ${option:-} \
      -d ' ' \
      --nth 1 \
      --height 100% \
      --ansi \
      --no-multi \
      --tiebreak=begin \
      --prompt='ᓆ > ' \
      --color='prompt:#0099BD' \
      --preview-window 'up,70%,wrap,rounded,<50(up,85%,border-bottom)' \
      --preview "${batman}" \
      --bind 'ctrl-p:preview-up,ctrl-n:preview-down' \
      --bind "ctrl-o:+change-preview(tldr --color {1})+change-prompt(ﳁ tldr > )" \
      --bind "ctrl-i:+change-preview(${batman})+change-prompt(ᓆ  man > )" \
      --bind "enter:execute(${batman})+change-preview(${batman})+change-prompt(ᓆ > )" \
      --header 'CTRL-N/P or SHIFT-↑/↓ to view preview contents; ENTER/Q to maximize/normal preview window' \
      --exit-0
}

# /**************************************************************
#  _           _
# | |         | |
# | |__   __ _| |_
# | '_ \ / _` | __|
# | |_) | (_| | |_
# |_.__/ \__,_|\__|
#
# **************************************************************/

# bat
help() { "$@" --help 2>&1 | bat --plain --language=help ; }

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh:foldmethod=marker:foldmarker=#\ **************************************************************/,#\ /**************************************************************
