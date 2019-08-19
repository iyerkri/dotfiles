#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias diff='diff --color=always'
PS1='[\u@\h \W]\$ '


export HISTCONTROL=ignoredups
export HISTSIZE=5000
export HISTFILESIZE=10000

msmtp-queue
