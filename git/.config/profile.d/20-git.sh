#!/bin/sh

# git amend and push
gcmp() {
  git status -s
  printf "Amend & force push (with new hash)? [y/N] "
  IFS= read -r ans || return
  case $ans in
    [Yy])
      GIT_COMMITTER_DATE="$(date)" git commit --amend --no-edit --date="$(date)" &&
        git push --force-with-lease
      ;;
    *) echo "Aborted." ;;
  esac
}
