#!/bin/bash

# file    calendar.sh
# date    2023-04-05
# author  Peter Zwettler <peter@zwettler.net>
# licence GNU General Public License version 3

calendarLoaded=1

eval includeDir="~/dev/scripts"

if [ "x${commonLoaded}" != 'x1' ] ; then
    source ${includeDir}/common.sh
fi

daysInMonth=(31 28 31 30 31 30 31 31 30 31 30 31)
months=(Jänner Februar März April Mai Juni Juli August September Oktober November Dezember)
weekDays=(Mo Di Mi Do Fr Sa So)

# Monday is first day of week
mifdow=1

isLeapYear() {
  local year=$1

  leap=0
  if ((year % 4 == 0)) ; then
    if ((year % 100 == 0)) ; then
      if ((year % 400 == 0)) ; then
        leap=1
      fi
    else
      leap=1
    fi
  fi
  echo "${leap}"
}

verifyIsLeapYear() {
    local year=$1
    local expectedResult=$2
    local result=`isLeapYear "${year}"`
    if [ "x${result}" == "x${expectedResult}" ] ; then
        color=$GREEN
        res="Ok"
    else
        color=$RED
        res="fail"
        ((errCount++))
    fi
    if [ "x${result}" = "x" ] ; then
        dispYear='---'
    else 
        dispYear=${year}
    fi
    echo -e "isLeapYear ${dispYear} ${year} ${color}${res}${NC}"
}

runTests() {
    verifyIsLeapYear 1900 0
    verifyIsLeapYear 2000 1
    verifyIsLeapYear 2023 0
    verifyIsLeapYear 2024 1
}

if [ "x${scriptName}" == "xcalendar.sh" ] ; then

    echo -e "${dispName}\n\n   should be included in other scripts:\n\n   source ./calendar.sh\n"
    echo -e "Let's run some tests\nsince we're already here:\n"
    runTests
    showDone
fi
