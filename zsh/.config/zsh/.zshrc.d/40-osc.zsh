#!/bin/zsh

# Terminal integration via OSC escape sequences:
#   OSC 7   - report cwd so new tabs/splits open in the same directory
#   OSC 133 - semantic prompt marks (jump-to-prompt, command status)
#   OSC 2   - window/tab title

function osc7_pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function osc7_chpwd() {
    (( ZSH_SUBSHELL )) || osc7_pwd
}

function osc133a_precmd () {
    print -Pn "\e]133;A\e\\"
}

function osc133c_preexec {
    print -n "\e]133;C\e\\"
}

function osc133d_precmd {
    local exit=$? # capture before anything clobbers it
    if ! builtin zle; then
        print -n "\e]133;D;${exit}\e\\"
    fi
}

function title_precmd () {
    print -Pn -- '\e]2;%n@%m:%~\a'
}

function title_preexec () {
    print -Pn -- '\e]2;%n@%m:%~ %# '
    print -n -- "${(q)1}\a"
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd osc7_chpwd
# D (previous command ended) is registered before A (new prompt started) so the
# region boundary is emitted in the correct order.
add-zsh-hook -Uz precmd osc133d_precmd
add-zsh-hook -Uz precmd osc133a_precmd
add-zsh-hook -Uz preexec osc133c_preexec
add-zsh-hook -Uz precmd title_precmd
add-zsh-hook -Uz preexec title_preexec
