#!/bin/bash

# file: cal.sh
# date: 2023-04-03
# author Peter Zwettler <peter@zwettler.net>


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
if [ "x${bdayLoaded}" != 'x1' ] ; then
    source ${includeDir}/cal/bday.sh
fi
if [ "x${holidayLoaded}" != 'x1' ] ; then
    source ${includeDir}/cal/holiday.sh
fi

descr="${scriptName} - print calendar"
helpMsg="usage: ${scriptName} [options]
options:
  -h               show help
  -m YYYY-MM       show month
"


curYear=`date +%Y`
curMonth=`date +%m`
curDay=`date +%d`
dayOfWeek=`date +%w`


FG_BLACK=30
FG_RED=31
FG_GREEN=32
FG_YELLOW=33
FG_BLUE=34
FG_MAGENTA=35
FG_CYAN=36
FG_WHITE=37

BG_BLACK=40
BG_RED=41
BG_GREEN=42
BG_YELLOW=43
BG_BLUE=44
FG_MAGENTA=45
BG_CYAN=46
BG_WHITE=47

setColor() {
    local FG=$1
    local BG-$2
    echo ""
}

# ┌ Mai 2022 ──────────────────┐   
# │ Mo  Di  Mi  Do  Fr  Sa  So │
monthWidgetWidth=30

repeatStr() {
    for (( i=1; i<=$1; i++ )) ; do echo -n "$2" ; done    
}

renderDay() {
    local year=$1
    local month=$2
    local day=$3

    printf -v fmtDay "%02u" "${day}"
    printf -v fmtMon "%02u" "${month}"    

    color=${NC}
    dayGuardFront=" "
    dayGuardBack=" "
    blinkStr=''
    if [ "x${year}" == "x${curYear}" ] ; then
        if [ "x${fmtMon}" == "x${curMonth}" ] ; then
            if [ "x${fmtDay}" == "x${curDay}" ] ; then
                blinkStr='\033[5m'
                dayGuardFront='\033[1:36m»\033[0m'
                dayGuardBack='\033[1:36m«\033[0m'
                blinkStr='\033[5m'
            fi
        fi
    fi
    nameBDay=`isBDay "${fmtMon}" "${fmtDay}"`
    if [ "x" != "x$nameBDay" ] ; then
        color=${YELLOW}
        isYellow=1
    fi
    nameHoliday=`isPubHoliday "${month}" "${day}"`
    if [ "x" != "x$nameHoliday" ] ; then
        color=${RED}
        isRed=1
    fi
    if [ "${isRed}" == "1" ] && [ "${isYellow}" == 1 ] ; then
        echo -n "${dayGuardFront}${YELLOW}${fmtDay:0:1}${RED}${fmtDay:1}${NC}${dayGuardBack}${NC}"
    else 
        echo -n "${dayGuardFront}${color}${fmtDay}${NC}${dayGuardBack}${NC}"

    fi
}

renderMonth() {
    local year=$1
    local month=`removeLeadingZero "$2"`
    
    widgetTitle="${months[${month} -1]} ${year}"
    lenTitle=${#widgetTitle}
    (( valTo = monthWidgetWidth - lenTitle - 4))
    tmp=`repeatStr $valTo '─'`
    curLine="┌ ${widgetTitle} ${tmp}┐"
    echo $curLine

    curLine="│"
    for ((i=0;i<7;i++)); do 
       color='\033[1;32m'
       (( i % 7 == 5 )) && color='\033[1:31m'
       (( i % 7 == 6 )) && color='\033[1:31m'
       curLine="${curLine}${color} ${weekDays[${i}]} ${NC}"    
    done
    curLine="${curLine}│"
    echo -e $curLine

    days=${daysInMonth[${month} - 1]}
    if ((month == 2)) ; then
      leap=$(isLeapYear $year)
      if ((leap == 1)) ; then
        ((days++))
      fi
    fi
    dayOfWeekFirst=`date -d "${year}-${month}-01" '+%w'`
    ((corrDayIdx=(dayOfWeekFirst + 6) % 7))
    curLine=""

    for ((i=1;i<=days;i++)); do

        if [ "$i" -eq 1 ] ; then
            tmp=`repeatStr $corrDayIdx "    "`    
            curLine="│${tmp}"
        fi
 
        tmp=`renderDay $year $month $i`
        curLine="${curLine}${tmp}"
        (( xVal = (corrDayIdx + i) % 7))
        if [ $xVal -eq 0 ] ; then
            curLine="${curLine}│"
            echo -e "${curLine}"
            curLine="│"
        fi        
    done
    if [ "x${curLine}" != "x│" ] ; then
        (( val = 7 - ((days + corrDayIdx) % 7) ))
        tmp=`repeatStr $val "    "`
        curLine="${curLine}${tmp}│"
        echo -e "${curLine}"
    fi
    echo "└────────────────────────────┘"
}

readBDays
readPubHolidays

showMonth=$curMonth
showYear=$curYear

while getopts "hm:" FLAG ; do
    case $FLAG in

        c) clean=1
           ;;

        h) echo "$helpMsg"
           exit 0
           ;;

        m) month=$OPTARG
           showYear=${month:0:4}
           showMonth=${month:5}
           ;;

        \?) echo "unrecognized option $OPTARG"
           echo "$helpMsg"
           exit 1
           ;;
    esac
done

fixedShowMonth=`removeLeadingZero "${showMonth}"`

echo ""
renderMonth "${showYear}" "${fixedShowMonth}"
echo ""
has=`hasBDaysMonth "${fixedShowMonth}"`
if [ "x1" == "x${has}" ] ; then
    echo "  Geburtstage im ${months[${fixedShowMonth} - 1]}"
    listBDaysMonth ${fixedShowMonth}
    echo ""
fi
has=`hasPubHolidaysMonth "${fixedShowMonth}"`
if [ "x1" == "x${has}" ] ; then
    echo "  Feiertage im ${months[${fixedShowMonth} - 1]}"
    listPubHolidaysMonth ${fixedShowMonth}
    echo ""
fi     
