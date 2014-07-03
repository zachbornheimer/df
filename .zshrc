#!/bin/zsh

# coepletion
autoload -U compinit
compinit
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# correction
setopt correctall

# Prompt
export PS1="%n %d > "

# history
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# Display
[[ -o interactive ]] && function TRAPINT {
    zle && print -nP '%B^C%b'
    return $(( 128 + $1 ))
}

# Fix key bindings
if [ $TERM = "xterm" ]
then
    bindkey "^H" backward-delete-char
fi

autoload zkbd
function zkbd_file() {
[[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE}.zsh_conf ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}.zsh_conf" && return 0
[[ -f ~/.zkbd/${TERM}-${DISPLAY}.zsh_conf          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}.zsh_conf"          && return 0
return 1
        }

        [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
        keyfile=$(zkbd_file)
        ret=$?
        if [[ ${ret} -ne 0 ]]; then
            zkbd
            keyfile=$(zkbd_file)
            ret=$?
        fi
        if [[ ${ret} -eq 0 ]] ; then
            source "${keyfile}"
        else
            printf 'Failed to setup keys using zkbd.\n'
        fi
        unfunction zkbd_file; unset keyfile ret

        # setup key accordingly
        [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
        [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
        [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
        [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
        [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
        [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
        [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char