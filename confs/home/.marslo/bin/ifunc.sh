#!/usr/bin/env bash
# shellcheck disable=SC1078,SC1079,SC2086
# =============================================================================
#    FileName : ifunc.sh
#      Author : marslo.jiao@gmail.com
#     Created : 2012
#  LastChange : 2023-12-21 16:56:51
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
  _p=$( [ 0 -eq $# ] && echo '.' || echo "$*" )
  find . -iname "${_p}" -print0 | xargs -r0 ${LS} -altr | awk '{print; total += $5}; END {print "total size: ", total}';
}

function dir-h() {
  _p=$( [ 0 -eq $# ] && echo '.' || echo "$*" )
  find . -iname "${_p}" -exec ${LS} -lthrNF --color=always {} \;
  find . -iname "${_p}" -print0 | xargs -r0 du -csh| tail -n 1
}

function rcsync() {
  SITE="Jira Confluence Jenkins Gitlab Artifactory Sonar Slave"
  HNAME=$( hostname | tr '[:upper:]' '[:lower:]' )
  for i in $SITE; do
    CURNAME=$( echo "$i" | tr '[:upper:]' '[:lower:]' )
    if [ "$HNAME" != "$CURNAME" ]; then
      echo ------------------- "$i" ---------------------;
      pushd "$PWD" || return
      cd "/home/appadmin" || return
      rsync \
        -avzrlpgoD \
        --exclude=Tools \
        --exclude=.vim/view \
        --exclude=.vim/vimsrc \
        --exclude=.vim/cache \
        --exclude=.vim/.netrwhist \
        --exclude=.ssh/known_hosts \
        -e 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ' \
        .marslo .vim .vimrc .inputrc .tmux.conf .pip appadmin@"$i":~/
      popd || return
    fi
  done
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

gtoc() {
  top=$(git rev-parse --show-toplevel)
  if [ 1 -eq $# ]; then
    case $1 in
      [mM] )
        top="${top}/docs"
        ;;
    esac
  fi
  xargs doctoc --github \
               --notitle \
               --maxlevel 3 >/dev/null \
         < <( fd . "${top}" --type f --extension md --exclude SUMMARY.md --exclude README.md )
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

# how may days == ddiff YYYY-MM-DD now
hmdays() {
  usage="""SYNOPSIS
  \n\t\$ hmdays YYYY-MM-DD
  \nEXAMPLE
  \n\t\$ hmdays 1987-03-08
  """

  if [ 1 -ne $# ]; then
    echo -e "${usage}"
  else
    if date +%s --date "$1" > /dev/null 2>&1; then
      echo $((($(date +%s)-$(date +%s --date "$1"))/(3600*24))) days
    else
      echo -e "${usage}"
    fi
  fi
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

function copy() {                          # smart copy
  if [[ 0 -eq $# ]]; then
    # shellcheck disable=SC2046
    /usr/bin/pbcopy < $(fzf --exit-0)
  else
    /usr/bin/pbcopy < "$1"
  fi
}

function cat() {                           # smart cat
  if [[ 0 -eq $# ]]; then
    # shellcheck disable=SC2046
    bat --theme='gruvbox-dark' $(fzf --exit-0)
  elif [[ '-c' = "$1" ]]; then
    $(type -P cat) "${@:2}"
  elif [[ 1 -eq $# ]] && [[ -d $1 ]]; then
    local target=$1;
    fd . "${target}" --type f --hidden --follow --exclude .git --exclude node_modules |
      fzf --multi --bind="enter:become(bat --theme='gruvbox-dark' {+})" ;
  else
    bat --theme='gruvbox-dark' "${@:1:$#-1}" "${@: -1}"
  fi
}

function vim() {                           # magic vim - fzf list in most recent modified order
  local target
  local fdOpt="--type f --hidden --follow --ignore-file $HOME/.fdignore --exec-batch ls -t"
  if [[ 0 -eq $# ]]; then
    fd . ${fdOpt} | fzf --multi --bind="enter:become($(type -P vim) {+})"
  elif [[ 1 -eq $# ]] && [[ -d $1 ]]; then
    [[ '.' = "${1}" ]] && target="${1}" || target=". ${1}"
    fd ${target} ${fdOpt} | fzf --multi --bind="enter:become($(type -P vim) {+})"
  else
    # shellcheck disable=SC2068
    $(type -P vim) -u $HOME/.vimrc $@
  fi
}

function v() {                             # v - open files in ~/.vim_mru_files
  local files
  files=$( grep --color=none -v '^#' ~/.vim_mru_files |
           while read -r line; do
             [ -f "${line/\~/$HOME}" ] && echo "$line"
           done | fzf-tmux -d -m -q "$*" -1
         ) && vim ${files//\~/$HOME}
}

function vimdiff() {                       # smart vimdiff
  local rPath
  local lPath

  if [[ 0 -eq $# ]]; then
    rPath='.'
    # shellcheck disable=SC2154
    lPath=". ${iRCHOME}"
  elif [[ 1 -eq $# ]] && [[ -d "$1" ]]; then
    [[ '.' = "${1}" ]] && lPath="${1}" || lPath=". ${1}"
  elif [[ 2 -eq $# ]] && [[ -d "$1" ]] && [[ -d "$2" ]]; then
    [[ '.' = "${1}" ]] && rPath="${1}" || rPath=". ${1}"
    [[ '.' = "${2}" ]] && lPath="${2}" || lPath=". ${2}"
  fi

  if [[ -z "${rPath}" ]] && [[ -z "${lPath}" ]]; then
    $(type -P vim) -d "$*"
  else
    fdOpt="--type f --hidden --follow --ignore-file $HOME/.fdignore --exec-batch ls -t"
    lfile="$(fd ${rPath} ${fdOpt} | fzf +m)" &&
    rfile="$(fd ${lPath} ${fdOpt} | fzf +m)" &&
    $(type -P vim) -d "${lfile}" "${rfile}"
  fi
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
  file=$(fzf +m -q "$1") && dir=$(dirname "${file}") && cd "${dir}"
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

function kns() {                           # [k]ubectl [n]ame[s]pace
  echo 'sms-fw-devops-ci sfw-vega sfw-alpine sfw-stellaris sfw-ste sfw-titania' |
        fmt -1 |
        fzf -1 -0 --no-sort +m --prompt='namespace> ' |
        xargs -i bash -c "echo -e \"\033[1;33m~~> {}\\033[0m\";
                          kubectl config set-context --current --namespace {};
                          kubecolor config get-contexts;
                         "
}

function eclr() {                          # [e]nvironment variable [c][l]ea[r]
  while read -r _env; do
    echo -e "$(c Ys)>> unset ${_env}$(c)\n$(c Wdi).. $(eval echo \$${_env})$(c)"
    unset "${_env}"
  done < <( echo 'LDFLAGS CFLAGS CPPFLAGS PKG_CONFIG_PATH LIBRARY_PATH' |
                  fmt -1 |
                  fzf -1 --exit-0 \
                         --no-sort \
                         --multi \
                         --prompt 'env> ' \
                         --header 'TAB/SHIFT-TAB to select multiple items, CTRL-D to deselect-all'
          )
  # echo -e "\n$(c Wdi)[TIP]>> to list all env via $(c)$(c Wdiu)\$ env | sed -rn 's/^([a-zA-Z0-9]+)=.*$/\1/p'$(c)"
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
