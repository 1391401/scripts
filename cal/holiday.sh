#!/bin/bash

# file    holiday.sh
# date    2023-03-27
# author  Peter Zwettler <peter.zwettler@itsv.at>
# licence GNU General Public License version 3

holidayLoaded=1

eval includeDir="~/dev/scripts"

if [ "x${commonLoaded}" != 'x1' ] ; then
    source ${includeDir}/common.sh
fi
if [ "x${calendarLoaded}" != 'x1' ] ; then
    source ${includeDir}/cal/calendar.sh
fi
if [ "x${easterLoaded}" != 'x1' ] ; then
    source ${includeDir}/cal/easter.sh
fi

curYear=`date +%Y`

eval dirPubHoliday="~/.config/cal/pub-holiday"

easterDate=`calcEaster ${curYear}`

readPubHolidays() {
    for fName in "${dirPubHoliday}"/* ; do    
        if [ -f "${fName}" ] ; then
            name=`basename "${fName}"`            
            holiday=$(head -n 1 "${fName}")
            if [[ "x${holiday:0:4}" == "xfix;" ]] ; then
                holientries+=("${holiday:4};${name}")
            elif [[ "x${holiday:0:7}" == "xeaster;" ]] ; then
                days=${holiday:7}
                holiDate=`date "+%m-%d" -d "${easterDate} + ${days} days"`
                holientries+=("${holiDate};${name}")
            fi            
        fi        
    done
    IFS=$'\n' pubHolidays=($(sort <<<"${holientries[*]}"))
}

isPubHoliday() {
    local month=`removeLeadingZero "$1"`
    local day=`removeLeadingZero "$2"`
    printf -v fmtMon "%02u" "${month}"    
    printf -v fmtDay "%02u" "${day}"    

    for entry in ${pubHolidays[@]} ; do
        entryMon=${entry:0:2}
        entryDay=${entry:3:2}
        entryName=${entry:6}
        if [ "x${fmtMon}" == "x${entryMon}" ] ; then 
            if [ "x${fmtDay}" == "x${entryDay}" ] ; then
                echo "${entryName}"
            fi
        fi        
    done
}

verifyIsPubHoliday() {
    local month=$1
    local day=$2
    local expectedName=$3
    name=`isPubHoliday "${month}" "${day}"`
    if [ "x${name}" == "x${expectedName}" ] ; then
        color=$GREEN
        res="Ok"
    else
        color=$RED
        res="fail"
        ((errCount++))
    fi
    if [ "x${name}" = "x" ] ; then
        dispName='---'
    else 
        dispName=${name}
    fi
    echo -e "  isPubHoliday ${expectedName} ${month}-${day} ${color}${res}${NC}"
}

listPubHolidays() {
    for entry in ${pubHolidays[@]} ; do
        echo "${entry}"
    done
}

hasPubHolidaysMonth() {
    local month=`removeLeadingZero $1`
    local count=0
    printf -v fmtMon "%02u" "${month}"    
    
    for entry in ${pubHolidays[@]} ; do
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

listPubHolidaysMonth() {
    local month=`removeLeadingZero "$1"`
    printf -v fmtMon "%02u" "${month}"    

    for entry in ${pubHolidays[@]} ; do
        entryMon=${entry:0:2}
        entryDay=${entry:3:2}
        entryName=${entry:6}
        if [ "x${fmtMon}" == "x${entryMon}" ] ; then 
            echo -e "  $RED${entryDay}.$NC ${entryName}"
        fi
    done
}

runTests() {
    eval dirPubHoliday="~/dev/scripts/cal/test/holiday"
    readPubHolidays
    verifyIsPubHoliday 01 04 "Some Day"
    verifyIsPubHoliday 1 4 "Some Day"
}

if [ "x${scriptName}" == "xholiday.sh" ] ; then

    echo -e "${dispName}\n\n   should be included in other scripts:\n\n   source ./holiday.sh\n"
    echo -e "Let's run some tests\nsince we're already here:\n"
    runTests
    showDone
fi
