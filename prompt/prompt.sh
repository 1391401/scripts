#!/bin/bash

# file    prompt.sh
# date    2023-04-03
# author  Peter Zwettler <peter@zwettler.net>
# license GNU General Public License version 3

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
NC='\e[m'

userColor=$GREEN
userChar='$'

if [ $EUID == 0 ]; then
  userColor=$RED
  userChar='#'
fi

export PS1="${userColor}\u${CYAN}@${YELLOW}\h${CYAN}:${NC}\w ${userColor}${userChar}${NC} "
