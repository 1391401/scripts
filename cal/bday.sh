#!/bin/bash

# file    bday.sh
# date    2023-04-05
# author  Peter Zwettler <peter@zwettler.net>
# licence GNU General Public License version 3

bdayLoaded=1

eval includeDir="~/dev/scripts"

if [ "x${commonLoaded}" != 'x1' ] ; then
    source ${includeDir}/common.sh
fi

eval dirBDay="~/.config/cal/bday"
colorBDay=$YELLOW

readBDays() {
    for fName in "${dirBDay}"/* ; do
        if [ -f "${fName}" ] ; then
            name=`basename "${fName}"`
            bDay=$(head -n 1 "${fName}")
            entries+=("${bDay};${name}")
        fi        
    done
    IFS=$'\n' birthDays=($(sort <<<"${entries[*]}"))
}

listBDays() {
    for entry in ${birthDays[@]} ; do
        echo ${entry}
    done
}

hasBDaysMonth() {
    local month=$1
    local count=0
    printf -v fmtMon "%02u" "${month}"    

    for entry in ${birthDays[@]} ; do
        entryMon=${entry:0:2}
        if [ "x${fmtMon}" == "x${entryMon}" ] ; then 
            ((count++))
        fi
    done
    if ((count > 0)) ; then
       echo 1
    else
       echo 0
    fi
}

listBDaysMonth() {
    local month=$1
    printf -v fmtMon "%02u" "${month}"    
    for entry in ${birthDays[@]} ; do
        entryMon=${entry:0:2}
        entryDay=${entry:3:2}
        entryName=${entry:6}
        if [ "x${fmtMon}" == "x${entryMon}" ] ; then 
            echo -e "  $YELLOW${entryDay}.$NC ${entryName}"
        fi
    done
}

isBDay() {
    local month=$1
    local day=$2
    for entry in ${birthDays[@]} ; do
        entryMon=${entry:0:2}
        entryDay=${entry:3:2}
        entryName=${entry:6}
        if [ "x${month}" == "x${entryMon}" ] ; then 
            if [ "x${day}" == "x${entryDay}" ] ; then
                echo "${entryName}"
            fi
        fi        
    done
}

verifyIsBDay() {
    local month=$1
    local day=$2
    local expectedName=$3
    local name=`isBDay "${month}" "${day}"`
    local color=$GREEN
    local res='Ok'
    if [ "x${name}" != "x${expectedName}" ] ; then
        color=$RED
        res="fail"
        ((errCount++))
    fi
    local dispName="${name}"
    if [ "x${name}" = "x" ] ; then
        dispName='---'
    fi
    echo -e "  isBDay ${month}-${day} '${dispName}'  ${color}${res}${NC}"
}

verifyHasBDaysMonth() {
    local month=$1
    local expectedResult=$2
    result=`hasBDaysMonth "${month}"`
    if [ "x${result}" == "x${expectedResult}" ] ; then
        color=$GREEN
        res='Ok'
    else
        color=$RED
        res='fail'
        ((errCount++))
    fi
    echo -e "  hasBDaysMonth $month ${color}${res}${NC}"
}

verifyListBDay() {
    local month=$1
    local expectedResult=$2
    result=`listBDaysMonth ${month}`
    if [ "x${result}" == "x${expectedResult}" ] ; then
        color=$GREEN
        res='Ok'
    else
        color=$RED
        res='fail'
        ((errCount++))
    fi
    echo -e "  listBDay $month ${color}${res}${NC}"
}

runTests() {
    eval dirBDay="~/dev/scripts/cal/test/bday"
    readBDays

    verifyIsBDay '01' '04' 'Foo'
    verifyIsBDay '02' '02' 'Clark Kent'
    verifyIsBDay '12' '13' 'Bar'
    verifyIsBDay '99' '98'

    verifyHasBDaysMonth '01' '1'
    verifyHasBDaysMonth '10' '0'

    exp=`echo -e "  ${YELLOW}04.${NC} Foo"`
    verifyListBDay 01 "$exp"
    verifyListBDay 10 ""
    exp=`echo -e "  ${YELLOW}13.${NC} Bar" && echo -e "  ${YELLOW}17.${NC} Baz"`
    verifyListBDay 12 "$exp"
}

if [ "x${scriptName}" == "xbday.sh" ] ; then

    echo -e "${dispName}\n\n   should be included in other scripts:\n\n   source ./bday.sh\n"
    echo -e "Let's run some tests\nsince we're already here:\n"
    runTests
    showDone
fi
