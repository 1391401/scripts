# scripts
Collection of bash scripts

## Common Functionality

The file *common.sh* contains common functionality used by many scripts.

## Command Line Calendar

The directory *cal* contains a command line calendar. 
The script *cal.sh* is loosely inspired by the *cal* command. 
With the parameter -m YYYY-MM the month to display can be selected.
In contrast to the *cal* command this script also lists birtdays and
holidays.

### Birthday

The script *bday.sh* is used by the script *cal.sh*. It contains the functionality for birthdays.
The directory *~/.config/cal/bday* contains birthday files. The file name is used as the persons name and the file contains the persons birtday in the format: **MM-DD**.

### Calendar

The script *calendar.sh* is used by the script *cal.sh*. It contains the calendar functionality.

 ### Easter

 The script *easter.sh* is used by the script *cal.sh*. It contains the functionality for calculating easter.

 ### Holiday

 The script *holiday.sh* is used by the script *cal.sh*. It contains the functionality for calculating holidays.
 The directory *~/.config/cal/pub-holiday* contains the files for holydays. The file name is used as the name of the holiday. The file for a holyday can have two different formats:
  * *fix;MM-DD* - the string fix followed by a smicolon and the month and the day of the holiday
  * *easter;n* - the string easter followed by a semicolon and the number of days after easter sunday.
