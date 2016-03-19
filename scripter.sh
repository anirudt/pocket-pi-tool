#!/bin/sh

# Git checker
git_exists() {
  type git &> /dev/null;
}


###################################################################
#                     Main Module                                 #
###################################################################
if git_exists; then
  echo "Hello"
fi
