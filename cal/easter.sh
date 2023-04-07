#!/bin/bash

# file    easter.sh
# date    2023-04-05
# author  Peter Zwettler <peter@zwettler.net>
# licence GNU General Public License version 3

easterLoaded=1

eval includeDir="~/dev/scripts"

if [ "x${commonLoaded}" != 'x1' ] ; then
    source ${includeDir}/common.sh
fi

# from wikipedia
calcEaster() {
  local y=$1
  (( a = y % 19 ))
  (( b = y / 100 ))
  (( c = y % 100 ))
  (( d = b / 4 ))
  (( e = b % 4 ))
  (( g = (8 * b + 13 ) / 25 ))
  (( h = (19 * a + b - d - g + 15) % 30 ))
  (( i = c / 4 ))
  (( k = c % 4 ))
  (( l = (32 + 2 * e + 2 * i - h - k) % 7 ))
  (( m = (a + 11 * h + 19 * l ) / 433 ))
  (( n = (h + l - 7 * m + 90) / 25 ))
  (( p = (h + l - 7 * m + 33 * n + 19) % 32))
  printf "%4u-%02u-%02u" $y $n $p
}

verifyEaster() {
    local expectedResult=$1
    local year="${expectedResult:0:4}"
    local result=`calcEaster $year`
    if [[ "x${result}" == "x${expectedResult}" ]] ; then
      color=$GREEN
    else
      color=$RED
      (( errCount++ ))
    fi
    echo -e "  ${color}${result}${NC}"
}

runTests() {
    verifyEaster 1609-04-19
    verifyEaster 1818-03-22
    verifyEaster 1886-04-25
    verifyEaster 1900-04-15
    verifyEaster 1943-04-25
    verifyEaster 1954-04-18
    verifyEaster 1961-04-02
    verifuEaster 1975-03-30
    verifyEaster 1981-04-19
    verifyEaster 2000-04-23
    verifyEaster 2008-03-23
    verifyEaster 2016-03-27
    verifyEaster 2022-04-17
    verifyEaster 2023-04-09
    verifyEaster 2024-03-31
    verifyEaster 2025-04-20
    verifyEaster 2038-04-25
    verifyEaster 2049-04-18
    verifyEaster 2076-04-19
    verifyEaster 2285-03-22
    verifyEaster 3002-04-25
    verifyEaster 3097-04-25
    verifyEaster 3401-03-22
    verifyEaster 3496-03-22
    verifyEaster 3716-03-22
    verifyEaster 4200-04-20
    verifyEaster 4308-03-22
}

if [ "x${scriptName}" == "xeaster.sh" ] ; then

    echo -e "${dispName}\n\n   should be included in other scripts:\n\n   source ./easter.sh\n"
    echo -e "Let's run some tests\nsince we're already here:\n"
    runTests
    showDone
fi
