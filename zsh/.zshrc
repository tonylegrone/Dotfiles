# options
bindkey -e
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line


# history
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt incappendhistory
setopt sharehistory
setopt extendedhistory


# path
typeset -U path
path+=(
)


# exports
EDITOR="nvim"
CLICOLOR=1


# aliases
alias la="gls -Al"
alias lt='gls -lhart'
alias ll="gls -lsvAt"
alias git="hub"
alias vim="nvim"

alias server-dev="ssh tlegrone@microfit.onyxlight.net"
alias server-prod="ssh chronicle@chroniclews1.onyxlight.net"
alias server-loc="ssh mfgserver@192.168.20.100"
alias server-remote="ssh mfgserver@jenkins.chroniclestudio.com"
alias server-rc="ssh royalcup@rccws1.onyxlight.net"
alias server-smeraglia="ssh tlegrone@skws1.onyxlight.net"

# prompt
setopt prompt_subst
autoload -U colors && colors
autoload -U promptinit; promptinit

function git_prompt_info() {
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
    local d
    local s
    # Rebasing
    if [ -d "$g/rebase-apply" ] ; then
      if test -f "$g/rebase-apply/rebasing" ; then
        r="|REBASE"
      fi
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    # Interactive rebase
    elif [ -f "$g/rebase-merge/interactive" ] ; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    # Merging
    elif [ -f "$g/MERGE_HEAD" ] ; then
      r="|MERGING"
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      if [ -f "$g/BISECT_LOG" ] ; then
        r="|BISECTING"
      fi
      if ! b="$(git symbolic-ref HEAD 2>/dev/null)" ; then
        if ! b="$(git describe --exact-match HEAD 2>/dev/null)" ; then
          b="$(cut -c1-7 "$g/HEAD")..."
        fi
      fi
    fi

    # Dirty Branch
    local newfile='?? '
    if [ -n "$ZSH_VERSION" ]; then
      newfile='\?\? '
    fi

    if [ -n "${1-}" ]; then
      d=''
      s=$(git status --porcelain 2> /dev/null)
      [[ $s =~ "$newfile" ]] && d+="+"
      [[ $s =~ "M " ]] && d+="*"
      [[ $s =~ "D " ]] && d+="-"
      printf "$1" "${b##refs/heads/}${r}${d}"
    else
      d=''
      s=$(git status --porcelain 2> /dev/null)
      [[ $s =~ "$newfile" ]] && d+="%{$fg[green]%} ⊕%{$reset_color%}"
      [[ $s =~ "M " ]] && d+="%{$fg[yellow]%} ⊙%{$reset_color%}"
      [[ $s =~ "D " ]] && d+="%{$fg[red]%} ⊝%{$reset_color%}"
      printf "%s " "%{$fg[magenta]%}${b##refs/heads/}%{$reset_color%}%{$fg[yellow]%}${r}%{$reset_color%}${d}"
    fi
  fi
}

# highlights the timestamp on error
function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  local EXIT_CODE_PROMPT=' '
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    EXIT_CODE_PROMPT+="%{$fg[red]%}(%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg[red]%}) %t%{$reset_color%}"
  else
    EXIT_CODE_PROMPT+="%{$fg[green]%}%t%{$reset_color%}"
  fi
  echo "$EXIT_CODE_PROMPT"
}

_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B'
PROMPT='%{$fg[blue]%}%2/%{$reset_color%} $(git_prompt_info)${_newline}❯ '

RPROMPT='%{${_lineup}%}$(check_last_exit_code)%{${_linedown}%}'


# enable autocompletion
autoload -U compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt completealiases


# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
FZF_DEFAULT_COMMAND="rg --no-ignore --hidden --files --follow -g '!{.git,node_modules,vendor,build,_build}'"
FZF_CTRL_T_COMMAND="rg --no-ignore --hidden --files --follow -g '!{.git,node_modules,vendor,build,_build}'"
FZF_ALT_C_COMMAND="fd --type d --exclude 'Library'"
export FZF_DEFAULT_OPTS='--color bw'

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash


# fasd
eval "$(fasd --init auto)"

# add homebrew sbin to $PATH
export PATH="$HOME/bin:/usr/local/sbin:$PATH"

# fancy handle long rg results
rg() {
  if [ -t 1 ]; then
    command rg -p "$@" | less -RMFXK
  else
    command rg "$@"
  fi
}
