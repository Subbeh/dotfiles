#!/bin/bash

tmux has-session -t infra
if [ $? != 0 ] ;  then

  INFRA=/data/workspace/infra

  tmux new-session -s infra -n main -d

  tmux send-keys -t infra "cd $INFRA" C-m
  tmux send-keys -t infra "vim" C-m

  tmux split-window -v -p 50 -t infra
  tmux select-layout -t infra main-horizontal
  tmux send-keys -t infra:1.2 "cd $INFRA" C-m
  tmux send-keys -t infra:1.2 "echo test" C-m

  tmux new-window -n servers -t infra
  tmux send-keys -t infra:2 "cd $INFRA" C-m

  tmux select-window -t infra:1
fi

tmux attach -t infra
