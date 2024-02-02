#-----------------------#
# .gitalias for git built with sh ( default git package ) instead of bash
#-----------------------#

[alias]
  aa          = add --all
  sts         = status
  rb          = rebase
  co          = checkout --force --recurse-submodules
  cl          = clean -dffx
  cn          = clone --recurse-submodules --tags
  cp          = cherry-pick
  wc          = whatchanged
  gca         = gc --aggressive
  fa          = fetch --prune --prune-tags --force --all
  ma          = merge --all --progress
  psa         = push origin --all
  pst         = push origin --tags
  root        = rev-parse --show-toplevel
  first       = rev-list --max-parents=0 HEAD
  last        = cat-file commit HEAD
  undo        = reset HEAD~1 --mixed
  slap        = blame -s -w -C -M
  stt         = status -sb
  # st        = "! bash -c 'while read branch; do \n\
  #                           git status -sb | head -1 \n\
  #                           git --no-pager diff --stat | head -n-1 \n\
  #                         done < <(git rev-parse --abbrev-ref HEAD) \n\
  #                        '"

  #-----------------------#
  # pretty show
  #-----------------------#
  # {{{
  # -p       : show patchset ( detail contents )
  # -M       : show renames
  # --follow : all logs including before renamed
  # --stat   : show a summary of the total additions and removals for that commit
  changes     = log -M --follow --stat --
  ### [p]retty [t]ag
  ls          = log --stat --pretty=short --graph
  ### [p]retty [l]og[s]
  pl          = !git --no-pager log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative --max-count=3
  pls         = log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative
  ### [p]revious branch [p]retty [l]og
  ppl         = !git --no-pager log --color --graph --pretty=tformat:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative --max-count=3 @{-1}
  ### [f]ull [p]retty [l]log
  fpl         = log --color --graph --pretty=tformat:'%C(red)%H%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr)%C(reset) %C(blue)<%an>%C(reset)' --abbrev-commit --date=relative
  fl          = log -p --graph --color --graph
  who-renamed ="! bach -c 'git log -M --summary | grep -E '^\\s*rename.*{.*=>.*}'"
  dl          = log --color --stat --abbrev-commit --date=relative --graph --submodule --format='%C(red)%h%Creset %C(yellow)(%ad)%Creset %s %C(blue)<%an>%Creset'
  revlog      = log --max-count=3 --color --graph --notes=linrev --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(blue)<%an>%Creset %N' --abbrev-commit --date=relative
  ### Showing all branches and their relationshps
  tree        = log --color --graph --pretty=oneline --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --decorate --abbrev-commit --all
  clog        = log --color --graph --all --decorate --simplify-by-decoration --oneline
  pshow       = show -s --pretty='tformat:%Cred%h%Creset %Cgreen(%s)%Creset'
  pt          = "! git for-each-ref --sort=-taggerdate refs/tags --format='%(color:red)%(objectname:short)%(color:reset) - %(align:left,38)%(color:bold yellow)[%(objecttype) : %(refname:short)]%(color:reset)%(end) %(subject) %(color:green)(%(if)%(taggerdate)%(then)%(taggerdate:format:%Y-%m-%d %H:%M:%S)%(else)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(end))%(color:reset) %(color:blue)%(if)%(taggername)%(then)<%(taggername)>%(else)<%(committername)>%(end)%(color:reset)' --color --count=10"
  pts         = "! git for-each-ref --sort=-taggerdate refs/tags --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)[%(objecttype) : %(refname:short)]%(color:reset) - %(subject) %(color:green)(%(if)%(taggerdate)%(then)%(taggerdate:format:%Y-%m-%d %H:%M:%S)%(else)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(end))%(color:reset) %(color:blue)%(if)%(taggername)%(then)<%(taggername)>%(else)<%(committername)>%(end)%(color:reset)' --color"
  # credit from https://www.everythingcli.org/git-like-a-pro-sort-git-tags-by-date/
  prettytags  = "! git for-each-ref --sort=-taggerdate --format='[%(tag)]_,,,_%(taggerdate:raw)_,,,_<%(taggername)>_,,,_%(subject)' refs/tags \
                       | awk 'BEGIN { FS = \"_,,,_\"  } ; { t=strftime(\"%Y-%m-%d  %H:%M\",$2); printf \"%-20s %-18s %-25s %s\\n\", t, $1, $4, $3  }'"
  stag        = tag --sort=-creatordate --format='%(creatordate:short)%09%(refname:strip=2)'
  # https://stackoverflow.com/a/40480534/2940319
  show-tags   = "! bash -c 'git show-ref -d --tags | cut -b 42- | sort | sed \"s/\\^{}//\" | uniq -c | sed \"s/2\\ refs\\/tags\\// a /\" | sed \"s/1\\ refs\\/tags\\//lw /\"'"
  rlog        = "! bash -c 'while read branch; do \n\
                              git fetch --all --force; \n\
                              git pl refs/remotes/origin/${branch}; \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           '"
  rlogs       = "! bash -c 'while read branch; do \n\
                              git fetch --all --force; \n\
                              git pls refs/remotes/origin/${branch}; \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           '"
  # https://stackoverflow.com/a/53535353/2940319
  ### [p]retty [b]ranch
  pb          = "! git for-each-ref refs/heads refs/remotes --sort=-committerdate --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(color:reset) - %(align:left,22)%(color:cyan)<%(authorname)>%(color:reset)%(end) %(color:bold red)%(if)%(HEAD)%(then)* %(else)  %(end)%(color:reset)%(refname:short)' --color --count=10"
  pbs         = "! git for-each-ref refs/heads refs/remotes --sort=-committerdate --format='%(color:red)%(objectname:short)%(color:reset) - %(color:bold yellow)%(committerdate:format:%Y-%m-%d %H:%M:%S)%(color:reset) - %(align:left,22)%(color:cyan)<%(authorname)>%(color:reset)%(end) %(color:bold red)%(if)%(HEAD)%(then)* %(else)  %(end)%(color:reset)%(refname:short)' --color"
  # git for-each-ref --sort=-committerdate ${refs} --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' --color=always | column -ts'|'; \
  ### sort local/remote branch via committerdate (DESC). usage: $ git recent; $ git recent remotes 10
  recent      = "!f() { \
                        declare help=\"USAGE: git recent [remotes|tags] [count]\"; \
                        declare refs; \
                        declare count; \
                        if [ 2 -lt $# ]; then \
                          echo \"${help}\"; \
                          exit 1; \
                        else \
                          if [ 'remotes' = \"$1\" ]; then \
                            refs='refs/remotes/origin'; \
                          elif [ 'tags' = \"$1\" ]; then \
                            refs='refs/tags'; \
                          elif [ 1 -eq $# ]; then \
                            count=$1; \
                          fi; \
                          if [ 2 -eq $# ]; then \
                            count=$2; \
                          fi; \
                        fi; \
                        git for-each-ref \
                            --sort=-committerdate \
                            ${refs:='refs/heads'} \
                            --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) %(color:green)(%(committerdate:relative))%(color:reset)' \
                            --color=always \
                            --count=${count:=5}; \
                    }; f \
                "
  # }}}

  #-----------------------#
  # branch
  #-----------------------#
  # {{{
  br          = branch --sort=-committerdate
  bra         = branch -a --sort=-committerdate
  ### [s]ort [b]ranch
  # sb        = "! git branch --sort=-committerdate --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(color:yellow)%(refname:short)%(color:reset) - %(subject) %(color:bold green)(%(committerdate:relative))%(color:reset) %(color:blue)<%(authorname)>%(color:reset)' --color=always"
  sbranch     = show-branch
  rbr         = "! f(){ git branch -ra | grep $1; }; f"
  # [c]urrent [b]ranch
  # cb        = rev-parse --abbrev-ref HEAD
  # curbranch = "!bash -c 'git branch | grep \* | sed "s/\* \(.*\)/ (\1)/"'"
  ### checkout sorted [b]ranch
  bb          = "! bash -c 'branch=$(git for-each-ref refs/remotes refs/heads --sort=-committerdate --format=\"%(refname:short)\" | \n\
                            grep --color=never -v \"origin$\" | \n\
                            fzf +m --prompt=\"branch> \" | \n\
                            sed -rn \"s:\\s*(origin/)?(.*)$:\\2:p\") && \n\
                            [[ -n \"${branch}\" ]] && \n\
                            echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" && \n\
                            git checkout \"${branch}\"; \n\
                           '"
  # bb        = "! bash -c 'git branch --color=never --all | \n\
  #                         grep -v --color=never HEAD | \n\
  #                         fzf | \n\
  #                         sed -rn \"s/^\\s*remotes\\/origin\\/(.*)$/\\1/p\" | \n\
  #                         xargs git checkout \n\
  #                        '"
  ### [b]ranch [copy]
  bcopy       = "! bash -c 'branch=$(git for-each-ref refs/remotes refs/heads --sort=-committerdate --format=\"%(refname:short)\" | \n\
                            grep --color=never -v \"origin$\" | \n\
                            fzf +m --prompt=\"branch> \" | \n\
                            sed -rn \"s:\\s*(origin/)?(.*)$:\\2:p\") && \n\
                            [[ -n \"${branch}\" ]] && \n\
                            echo -e \"\\033[0;33;1m~~> branch \\033[0m\\033[0;32;3m${branch}\\033[0m \\033[0;33;1mcopied\\033[0m\" && \n\
                            pbcopy <<< \"${branch}\" \n\
                           '"
  # }}}

  #-----------------------#
  # commit && push
  #-----------------------#
  # {{{
  ci          = commit -m
  ### [c]ommit --[a]llow [e]mepty
  cae         = commit --allow-empty -am
  ### [c]ommit [a]dd [a]all
  caa         = "!f(){ git add --all && git commit --amend --no-edit --allow-empty; }; f"
  ### [c]ommit --no-ed[i]t --ame[n]d --allow-empty
  cin         = commit --amend --no-edit --allow-empty
  cij         = commit --amend --no-edit --allow-empty --author "marslo <marslo@domain.com>"
  caj         = commit --author "marslo <marslo.jiao@gmail.com>" -m
  # [c]ommit -[a]m
  ca          = "!f() { \
                        git add --all $(git rev-parse --show-toplevel) ; \
                        git commit -am \"$1\" ; \
                      }; f \
                "
  ### [c]omm[i]t --[a]mend
  cia         = "!f() { \
                        declare authorDate=\"${GIT_AUTHOR_DATE}\"; \
                        declare commiterDate=\"${GIT_COMMITTER_DATE}\"; \
                        OPT='commit --amend --allow-empty'; \
                        if [ 0 -eq $# ]; then \
                          git ${OPT} ; \
                        else \
                          if [ \"o\" = \"$1\" ] || [ \"original\" = \"$1\" ]; then \
                            declare dd=\"$(git log -n 1 --format=%aD)\"; \
                            export GIT_AUTHOR_DATE=\"${dd}\"; \
                            export GIT_COMMITTER_DATE=\"${dd}\"; \
                            git ${OPT} --date=\"${dd}\" -m \"${@:2}\" ; \
                          else \
                            git ${OPT} -m \"$@\" ; \
                          fi; \
                          unset GIT_AUTHOR_DATE; \
                          unset GIT_COMMITTER_DATE; \
                        fi; \
                      }; f \
                "

  ### [m]arslo force [p]ush
  mp          = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                              git add --all $(git rev-parse --show-toplevel) \n\
                              git commit --amend --no-edit \n\
                              if [ 'meta/config' = \"${branch}\" ]; then \n\
                                git push -u --force origin HEAD:refs/meta/config \n\
                                git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config ; \n\
                                git reset --hard remotes/origin/${branch} ; \n\
                              else \n\
                                git push -u --force origin ${branch} \n\
                              fi \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "

  # [c]ommit [a]nd [p]ush
  cap         = "! bash -c 'while read branch; do \n\
                              git add --all .; \n\
                              git commit -am \"${0}\"; \n\
                              git push origin $branch; \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "
  # [c]ommit [f]orce [m]erge [p]ush
  cfmp        = "! bash -c 'while read branch; do \n\
                              git add --all .; \n\
                              git commit -aqm \"${0}\"; \n\
                              git fetch --all --force; \n\
                              git merge --all --progress remotes/origin/$branch; \n\
                              git push origin $branch; \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "
  # }}}

  #-----------------------#
  # Change-Id
  #-----------------------#
  # {{{
  ### [c]hange-[i][d]
  cid         = "!f() { \
                        ref='HEAD'; \
                        if [ 0 -ne $# ]; then ref=\"$@\"; fi; \
                        echo \"\\033[1;33m~~> Commit-Id : Change-Id :\\033[0m\"; \
                        git --no-pager log -1 --no-color ${ref} | \
                            sed -nr 's!^commit\\s*(.+)$!\\1!p; s!^\\s*Change-Id:\\s*(.*$)!\\1!p' | \
                            awk '{ key=$0; getline; print key \" : \" $0; }'; \
                      }; f \
                "
  ### [c]hange-[i][d] -[n]
  cidn        = "!f() { \
                        OPT='-3'; \
                        if [ 0 -ne $# ]; then OPT=\"$@\"; fi; \
                        echo \"\\033[1;33m~~> Commit-Id : Change-Id :\\033[0m\"; \
                        git --no-pager log --no-color ${OPT} | \
                            sed -nr 's!^commit\\s*(.+)$!\\1!p; s!^\\s*Change-Id:\\s*(.*$)!\\1!p' | \
                            awk '{ key=$0; getline; print key \" : \" $0; }'; \
                      }; f \
                "
  ### [c]hange-[i][d] to [r]evsion
  cidr        = "!f() { \
                        if [ 0 -ne $# ]; then \
                          changeId=\"$@\" ; \
                          for _i in $(git rev-list --do-walk HEAD); do \
                            if git --no-pager show ${_i} --no-patch --format='%B' | grep -F \"Change-Id: ${changeId}\" >/dev/null 2>&1; then \
                              echo ${_i} ; \
                              break ; \
                            fi ; \
                          done ; \
                        else \
                          exit 1; \
                        fi; \
                      }; f \
                "
  ### [c]hange-[id] rev-[c]ount
  cidc            = "!f() { \
                            echo \"\\033[1;33m~~> Revision-Count : Commit-Id : Change-Id :\\033[0m\"; \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision; do \
                                  cid=$(git show -s \"${revision}\" --format='%B' | sed -rn 's/^\\s*Change-Id:\\s*(.+)$/\\1/p') ; \
                                  if [[ \"${cid}\" = \"$1\" ]]; then echo \"${number} : ${revision} : ${cid}\"; break; fi; \
                                done; \
                          }; f"

  ### [c]hange-[id][s] rev-count
  cids            = "!f() { \
                            echo \"\\033[1;33m~~> Revision-Count : Commit-Id : Change-Id :\\033[0m\"; \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision; do \
                                  cid=$(git show -s \"${revision}\" --format='%B' | sed -rn 's/^\\s*Change-Id:\\s*(.+)$/\\1/p') ; \
                                  echo \"${number} : ${revision} : ${cid}\"; \
                                  if [[ \"${cid}\" = \"$1\" ]]; then break; fi; \
                                done; \
                          }; f"
  # }}}

  #-----------------------#
  # conflict
  #-----------------------#
  # {{{
  ### [c]onflict [f]ile
  cf          = "! bash -c 'grep --color=always -rnw \"^<<<<<<< HEAD$\"'"
  # [s]how [c]onflict [c]ontent
  scc         = "! bash -c 'while read file; do \n\
                              echo -e \"\\n\\033[1;33m${file}\\n---\\033[0m\" \n\
                              sed -n \"/<<<<<<< HEAD/,/>>>>>>> /!d;=;p\" ${file} \n\
                              echo -e \"\\n\\033[1;33m---\\033[0m\" \n\
                            done < <(git grep --no-color -l \"<<<<<<< HEAD\") \n\
                           ' \n\
                "
  # [c]onflict [f]ile [n]ame
  cfn         = diff --name-only --diff-filter=U --relative
  # }}}

  #-----------------------#
  # submodule
  #-----------------------#
  # {{{
  ### [s]ubmodel [u]pdate
  su          = "!bash -c 'git submodule sync --recursive && git submodule update -f --init --recursive'"
  sub         = submodule
  subpull     = !git pull && git submodule sync --recursive && git submodule update --init --recursive
  subupdate   = submodule update --remote --merge
  subst       = submodule foreach \"git status\"
  # }}}

  #-----------------------#
  # revision
  #-----------------------#
  # {{{
  # retag       = !bash -c 'source /Users/marslo/.marslo/bin/ig.sh && grt "$*"'
  # }}}

  #-----------------------#
  # revision
  #-----------------------#
  # {{{
  show-rev        = "!f(){ git rev-list --count $1; }; f"
  rev-number      = "!bash -c 'git rev-list --reverse HEAD | nl | sort -nr | awk \"{ if(\\$1 == "$0") { print \\$2 }}\"'"
  rev-count       = "!f() { \
                            declare hash=$(git rev-parse \"$1\"); \
                            git rev-list --no-color --reverse HEAD | nl | sort -nr | \
                                while read number revision ; do \
                                  if [[ \"${revision}\" = \"${hash}\" ]]; then echo \"${number}\"; break; fi; \
                                done; \
                          }; f"
  show-remote-rev = "!bash -c 'git ls-remote --heads $(git config --get remote.origin.url) | \n\
                               grep \"refs/heads/$0\" | \n\
                               cut -f 1 \n\
                              ' \n\
                    "
  revset          = "!bash -c 'ix=0; for ih in $(git rev-list --reverse HEAD); do \n\
                                 TCMD=\"git notes --ref linrev\"; \n\
                                 TCMD=\"$TCMD add $ih -m \\\"(r\\$((++ix)))\\\"\"; \n\
                                 eval \"$TCMD\"; \n\
                               done; \n\
                               echo \"Linear revision notes are set.\" \n\
                              ' \n\
                    "
  revunset        = "!bash -c 'ix=0; for ih in $(git rev-list --reverse HEAD); do \n\
                                 TCMD=\"git notes --ref linrev\"; \n\
                                 TCMD=\"$TCMD remove $ih\"; \n\
                                 eval \"$TCMD 2>/dev/null\"; \n\
                               done; \n\
                               echo \"Linear revision notes are unset.\" \n\
                              ' \n\
                    "
  # }}}

  #-----------------------#
  # utility
  #-----------------------#
  # {{{
  in          = info --no-config
  info        = info --no-config
  # info      = !bash -l -c 'gitinfo'
  # info      = !bash -c '. ~/.marslo/.marslorc && gitinfo'
  ls-effort   = !git log --pretty=format: --name-only | sort | uniq -c | sort -rg
  tagcommit   = rev-list -1

  # https://stackoverflow.com/q/53841043/2940319
  ### show [g]it alia[s]
  as         = "! bash -c '''grep --no-group-separator -A1 -e \"^\\s*###\" \"$HOME\"/.marslo/.gitalias | \n\
                              awk \"END{if((NR%2))print p}!(NR%2){print\\$0p}{p=\\$0}\" | \n\
                              sed -re \"s/( =)(.*)(###)/*/g\" | \n\
                              sed -re \"s:[][]::g\" | \n\
                              awk -F* \"{printf \\\"\\033[1;33m%-20s\\033[0m » \\033[0;34m%s\\033[0m\\n\\\", \\$1, \\$2}\" | \n\
                              sort \n\
                          ''' \n\
                "
  # https://brettterpstra.com/2014/08/04/shell-tricks-one-git-alias-to-rule-them-all/
  ### [find] [a]lias by keywords
  finda = "!grepalias() { git config --get-regexp alias | \
                          grep -i \"$1\" | \
                          awk -v nr=2 '{ \
                                         sub(/^alias\\./,\"\") }; \
                                         {printf \"\\033[31m%15s :\\033[1;37m\", $1}; \
                                         {sep=FS}; \
                                          { for (x=nr; x<=NF; x++) {printf \"%s%s\", sep, $x; }; print \"\\033[0;39m\" \
                                      }'; \
                        }; grepalias"
  # [m]arslo [h]elp
  mh          = "!f() { \
                        declare help=\"\"\"\
                          marslo specific git alias \n\n\
                          EXPLATIOIN: \n\
                             ca = git commit -am \n\
                            cae = git commit --allow-empty -am \n\
                            caa = git add --all && git commit --amend --no-edit --allow-empty \n\
                            cia = git commit --amend --allow-empty [-m <comments>] \n\
                            cin = commit --amend --no-edit --allow-empty \n\
                             mp = git caa & git push --force -u <current-brancha> \n\
                             mw = git caa & git review <current-branch> \n\
                             ro = git fetch all & git reset --hard origin/<current-branch> \n\
                        \"\"\"; \
                        echo \"${help}\"; \
                      }; f\
                "

  # if a branch name is specified, on top of the specified branch.
  ### [m]erge github [p]ull [r]equest on top of the current branch or,
  mpr         = "!f() { \
                        declare currentBranch=\"$(git symbolic-ref --short HEAD)\"; \
                        declare branch=\"${2:-$currentBranch}\"; \
                        if [ $(printf \"%s\" \"$1\" | grep '^[0-9]\\+$' > /dev/null; printf $?) -eq 0 ]; then \
                            git fetch origin refs/pull/$1/head:pr/$1 && \
                            git checkout -B $branch && \
                            git rebase $branch pr/$1 && \
                            git checkout -B $branch && \
                            git merge pr/$1 && \
                            git branch -D pr/$1 && \
                            git commit --amend -m \"$(git log -1 --pretty=%B)\n\nClose #$1\"; \
                        fi \
                      }; f \
                "

  init-repo   = "!f() { \
                        declare help=\"\"\"\
                          USAGE: git init-repo <REMOTE_URL> [DEFAULT_BRANCH] [LOCAL_DIR] \n\n\
                          OPT: \n\
                                REMOTE_URL : mandatory \n\
                            DEFAULT_BRANCH : optinal. default is 'master' \n\
                                 LOCAL_DIR : optional. default is current directory: '\"$(pwd)\"' \n\
                        \"\"\"; \
                        declare remoteURL=\"$1\"; \
                        declare defaultBr='master'; \
                        declare localDir='.'; \
                        [ 2 -le $# ] && defaultBr=\"$2\"; \
                        [ 3 -eq $# ] && localDir=\"$3\"; \
                        if [ 0 -eq $# ] || [ 3 -lt $# ]; then \
                          echo \"${help}\"; \
                        else \
                          [ -d ${localDir} ] || mkdir -p ${localDir}; \
                          cd ${localDir} ; \
                          git init && \
                          git remote add origin ${remoteURL} && \
                          git fetch --all --force --quiet && \
                          git checkout -b ${defaultBr}; \
                        fi \
                      }; f \
                "

  ### [m]eta/[c]onfig checkout
  mc          = "!f() { \
                        if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then \
                          git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config; \
                          git checkout meta/config; \
                        else \
                          echo \"current directory isn't inside the git working tree\" ; \
                        fi \
                      }; f \
                "
  add-fetch   = "! sh -c 'git config --add remote.$0.fetch \"+refs/heads/$1:refs/remotes/$0/$1\"'"
  add-refs    = "!f() { \
                        declare help=\"\"\" \
                          USAGE: \n\
                            git add-refs [REMOTE] [BRANCH] \n\n\
                          EXMAPLE: \n\
                            add +refs/heads/*:+refs/remotes/origin/* : \n\
                              $ git add-refs \n\
                            add +refs/heads/<branch>:+refs/remotes/origin/<branch> : \n\
                              $ git add-refs <branch> \n\
                            add +refs/heads/<branch>:+refs/remotes/<new-origin>/<branch> : \n\
                              $ git add-refs <branch> <new-origin> \n\
                        \"\"\"; \
                        if [ 0 -eq $# ]; then \
                          rn='remote.origin.fetch'; \
                          sp='+refs/heads/*:refs/remotes/origin/*'; \
                        elif [ 1 -eq $# ]; then \
                          rn='remote.origin.fetch'; \
                          sp='+refs/heads/'\"${1}\":'refs/remotes/origin/'\"${1}\"; \
                        elif [ 2 -eq $# ]; then \
                          rn='remote.'\"$2\"'.fetch'; \
                          sp='+refs/heads/'\"$1\":'refs/remotes/'\"$2\"/\"$1\"; \
                        else \
                          echo \"${help}\"; \
                          exit 1; \
                        fi; \
                        matches=0; \
                        for s in $(git config --get-all ${rn}); do [[ \"${s}\" = \"${sp}\" ]] && matches=1; done; \
                        if [ '1' -eq \"${matches}\" ]; then \
                          echo \"${sp} already exists in ${rn}.\"; \
                        else \
                          git config --add \"${rn}\" \"${sp}\"; \
                        fi; \
                      }; f \
                "

  # git fetch --prune origin 'refs/tags/*:refs/tags/*' '+refs/heads/*:refs/remotes/origin/*'
  ### [u]pdate [a]ll
  ua          = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                              git fetch --all --force; \n\
                              git fetch --prune --prune-tags --force origin; \n\
                              if [ 'meta/config' = \"${branch}\" ]; then \n\
                                git fetch origin --force refs/${branch}:refs/remotes/origin/${branch} \n\
                              fi \n\
                              git rebase -v refs/remotes/origin/${branch}; \n\
                              git merge --all --progress refs/remotes/origin/${branch}; \n\
                              git remote prune origin; \n\
                              if git --no-pager config --file $(git rev-parse --show-toplevel)/.gitmodules --get-regexp url; then \n\
                                git submodule sync --recursive; \n\
                                git submodule update -f --init --recursive \n\
                              fi \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "

  # [r]eset --h[a]rd
  ra          = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                              git reset --hard origin/${branch} \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "

  # https://gerrit-review.googlesource.com/Documentation/user-upload.html#push_options
  # https://gerrit-review.googlesource.com/Documentation/user-upload.html#push_create
  # git review ${branch} --reviewers a@domain.com b@domain.com c@domain.com cc:e@domain.com \n\
  ### [m]arslo revie[w]
  mw          = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\"; \n\
                              if [ 'meta/config' = \"${branch}\" ]; then \n\
                                git push origin HEAD:refs/for/refs/meta/config; \n\
                              else \n\
                                git push origin HEAD:refs/for/${branch}%r=a@domain.com,r=b@domain.com,r=c@domain.com,r=d@domain.com,cc=e@domain.com; \n\
                              fi; \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "

  ### [p]ure [m]arslo revie[w]
  pmw         = "! bash -c 'while read branch; do \n\
                              echo -e \"\\033[1;33m~~> ${branch}\\033[0m\" \n\
                              if [ 'meta/config' = \"${branch}\" ]; then \n\
                                git push origin HEAD:refs/for/refs/meta/config \n\
                              else \n\
                                git review ${branch} \n\
                              fi \n\
                            done < <(git rev-parse --abbrev-ref HEAD) \n\
                           ' \n\
                "

  # `echo` for MacOS (sh); `echo -e` for Linux (bash); \
  ### [r]eset to [o]riginal
  ro          = "!f() { \
                        ECHO='echo'                                    ; \
                        if [ 0 -eq $# ]; then \
                          branch=$(git rev-parse --abbrev-ref HEAD)    ; \
                        else \
                          branch=\"$*\"                                ; \
                        fi                                             ; \
                        ${ECHO} \"\\033[1;33m~~> ${branch}\\033[0m\"   ; \
                        if [ 'meta/config' = \"${branch}\" ]; then \
                          git fetch origin --force refs/meta/config:refs/remotes/origin/meta/config ; \
                        else \
                          git fetch --all --prune --prune-tags --force ; \
                        fi                                             ; \
                        git reset --hard remotes/origin/${branch}      ; \
                        git clean -dffx                                ; \
                        if git --no-pager config --file $(git rev-parse --show-toplevel)/.gitmodules --get-regexp url; then \
                          git submodule foreach --recursive git clean -dffx  ; \
                          git submodule foreach --recursive git reset --hard ; \
                          git submodule update -f --init --recursive         ; \
                        fi ; \
                      }; f \
                "

  # `echo` for MacOS (sh); `echo -e` for Linux (bash); \
  ### [r]eset to [o]riginal and re[b]ase
  rob         = "!f() { \
                        ECHO='echo'                                 ; \
                        if [ 0 -eq $# ]; then \
                          branch=$(git rev-parse --abbrev-ref HEAD) ; \
                        else \
                          branch=\"$*\"                             ; \
                        fi ; \
                        git ro ${branch}                            ; \
                        if [ 0 -ne $# ]; then \
                          ${ECHO} \"\\033[1;33m~~> rebase from : ${branch}\\033[0m\"   ; \
                          git rebase \"${branch}\"                  ; \
                        fi ; \
                      }; f \
                "

  ### [r]ebase & s[q]uash
  sq          = "! f() { TARGET=$1 && GIT_EDITOR=\"sed -i -e '2,$TARGET s/^pick /s /;/# This is the 2nd commit message:/,$ {d}'\" git rebase -i HEAD~$TARGET; }; f"
  # sq        = "! f() { NL=$1; GIT_EDITOR=\"sed -i '2,$NL s/^pick/squash/;/# This is the 2nd commit message:/,$ {d}'\"; git rebase -i HEAD~$NL; }; f"
  # }}}

  #-----------------------#
  # diff
  #-----------------------#
  # {{{
  ### [d]iff with [r]emote branch
  rd          = diff @{u}..@
  ### [d]iff with [p]revious branch
  pd          = diff @{-1}..@
  #### [d]iff [f]ile name only
  fd          = diff --name-status
  #### [d]iff via colorful [w]ords
  wd          = diff --color-words -U0
  # [l]ine [d]iff
  ld          = !bash -c '. ~/.marslo/.gitrc && git diff -U0 \"$@\" | diff-lines' -
  # ld        = !bash -l -c 'git diff -U0 "$@" | diff-lines' -
  ldiff       = diff -U0
  diffremote  = "!bash -c 'while read branch; do \n\
                             git fetch origin $branch; \n\
                             git ld $branch remotes/origin/$branch; \n\
                           done < <(git rev-parse --abbrev-ref HEAD) \n\
                          '"
  diffname    = git diff --name-only
  diffbranch  = log --left-right --graph --cherry-pick --oneline
  sortdiff    = !sh -c 'git diff "$@" | grep "^[+-]" | sort --key=1.2 | uniq -u -s1'
  # }}}

  #-----------------------#
  # others
  #-----------------------#
  # {{{
  prepo      = "! bash -c \"git config credential.helper store; git config user.name marslo; git config user.email marslo.jiao@gmail.com; git config alias.ro 'pull --rebase'\""
  task        = grep -EI \"TODO|FIXME\"
  search      = ! git rev-list --all | xargs git grep -F
  # debug git aliases - 'git debug <alias>'
  debug       = "! set -x; GIT_TRACE=2 GIT_CURL_VERBOSE=2 GIT_TRACE_PERFORMANCE=2 GIT_TRACE_PACK_ACCESS=2 GIT_TRACE_PACKET=2 GIT_TRACE_PACKFILE=2 GIT_TRACE_SETUP=2 GIT_TRACE_SHALLOW=2 git"
  # credit from https://www.everythingcli.org/git-like-a-pro/
  ### ignored files
  ign         = ls-files -o -i --exclude-standard
  make-patch  = "! bash -c \"git format-patch HEAD~1; git reset HEAD~1\""
  pdraft      = !git push origin HEAD:refs/drafts/$1
  ghook       = "!bash -c 'scp -p -O -P 29418 vgitcentral.example.com:hooks/commit-msg $(git rev-parse --git-dir)/hooks/'"
  ghprofile   = "! bash -c 'git config user.email \"marslo.jiao@gmail.com\"; \n\
                            git config user.name \"marslo\" \n\
                           '"
  # https://stackoverflow.com/a/39616600/2940319
  ### convert anything into sh+ : `\"` -> `\\\"`
  quote-string      = "!read -r l; printf \\\"!; printf %s \"$l\" | sed 's/\\([\\\"]\\)/\\\\\\1/g'; printf \" #\\\"\\n\" #"
  quote-string-undo = "!read -r l; printf %s \"$l\" | sed 's/\\\\\\([\\\"]\\)/\\1/g'; printf \"\\n\" #"
  showupstream      = "! bash -c 'while read branch; do \n\
                                    upstream=$(git rev-parse --abbrev-ref ${branch}@{upstream} 2>/dev/null); \n\
                                    if [[ $? = 0 ]]; then \n\
                                      echo -e \"${branch} tracks ${upstream}\"; \n\
                                    else \n\
                                      echo -e \"${branch} has no upstream configured\"; \n\
                                    fi; \n\
                                  done < <(git for-each-ref --format=\"%(refname:short)\" refs/heads/*) \n\
                                 ' \n\
                      "
  # get line changer statistic
  impact            = "!git ls-files -z \
                            | xargs -0n1 git blame -w \
                            | perl -n -e '/^.*?\\((.*?)\\s+[\\d]{4}/; print $1,\"\\n\"' \
                            | sort -f \
                            | uniq -c \
                            | sort -nr"
  # }}}

  #-----------------------#
  # deprecated
  #-----------------------#
  # {{{
  show-cmd        = "!f() { \
                              sep="㊣" ;\
                              name=${1:-alias};\
                              echo "$name"; \
                              git config --get-regexp ^$name\\..*$2+ | \
                              cut -c 1-40 | \
                              sed -e s/^$name.// \
                              -e s/\\ /\\ $(printf $sep)--\\>\\ / | \
                              column -t -s $(printf $sep) | \
                          }; f \
                    "
  # }}}

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=gitconfig:foldmethod=marker
