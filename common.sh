#!/bin/bash

# file    common.sh
# date    2023-04-05
# author  Peter Zwettler <peter@zwettler.net>
# licence GNU General Public License version 3

commonLoaded=1

# --- color definitions for CLI ---
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

BLACK_ON_CYAN='\033[30;46m'
WHITE_ON_BLUE='\033[37;44m'

data_col=40
sep="--------------------"
sepLine="${sep}${sep}${sep}${sep}"

errCount=0
scriptStart=`date +%s`
statFile="/dev/null"
# statFile="stat.txt"

showStatus() {
    local status=$1
    local message=$2
    local color="${GREEN}"
    local okOrNot='Ok'
    if (( ${status} > 0 )); then
      color=${RED}
      okOrNot='Fail'
      ((errCount++))
    fi
    if [ -n $message ]; then
      echo -e "${color}${okOrNot}${NC}\n"  
    else
      echo -e "${message} ${color}${okOrNot}${NC}\n"
    fi
}

showStatusExit() {
    local status=$1
    local message=$2
    showStatus "${status}" "${message}"
    if ((errCount > 0)); then
      showDone
      exit ${errCount}
    fi
}

showMessage() {
    local data=$1
    local message=$2
    local color=$3

    echo -e "${message} ${color}${data}${NC}"
}

showDone() {
    local color=${GREEN}
    local smiley=':-)'
    if (( $errCount > 0 )); then
      color=${RED}
      smiley=':-('
    fi   
    echo "" 
    echo "${sep}${sep}"
    curTS=`date --rfc-3339=seconds`
    echo -e "finished: ${WHITE}${curTS}${NC}"
    scriptFinish=`date +%s`
    scriptDuration=$(($scriptFinish - $scriptStart))
    echo -e "duration: ${WHITE}${scriptDuration}${NC} sec."
    echo -e "error(s): ${color}${errCount}${NC}"
    echo "${sep}${sep}"
    echo ""
    echo -e "${WHITE}done${NC} ${color}${smiley}${NC}"    
    echo "${curTS} ${scriptName} ${smiley} ${errCount} ${scriptDuration}" >> ${statFile}
    echo ""
}

getValueFromLine() {
    local retVar=$1
    local key=$2
    local line=$3
    local len=${#key}

    if [ "x${line:0:$len}" == "x${key}" ]; then
        echo "${line:$len}"
    fi
}

removeLeadingZero() {
    local number=$1
    if [ "x${number:0:1}" = 'x0' ] ; then
        echo "${number:1:1}"
    else 
        echo "${number}"
    fi
}

verifyRemoveLeadingZero() {
    local number=$1
    local result=`removeLeadingZero "${number}"`
    local expectedResult=$2
    local res='Ok'
    local color=$GREEN
    if [ "x${result}" != "x${expectedResult}" ] ; then
        color=$RED
        res="fail"
        ((errCount++))
    fi
    echo -e "  removeLeadingZero '${number}' -> '${result}'  ${color}${res}${NC}"
}

runTests() {
    verifyRemoveLeadingZero "01" "1"
}

scriptName=`basename "$0"`
scriptPath=`dirname "$0"`
dispName=${WHITE}${scriptName}${NC}
appName="${scriptName%.*}"
eval configDir="~/.config/${appName}"
configFile="${configDir}/${appName}.conf"

if [ "x${scriptName}" == "xcommon.sh" ] ; then

    echo -e "${dispName}\n\n   should be included in other scripts:\n\n   source ./common.sh\n\n"
    echo -e "Let's run some tests\nsince we're already here:\n"
    runTests

    showDone
fi
