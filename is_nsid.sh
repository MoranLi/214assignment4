#!/bin/sh
# Author: Yukun LI
# NSID: yul040
# shell script to ckeck if input is a string as "nsid" format
# echo $? to check exit status

# function check format based on input
is_nsid(){
  if egrep "^[a-z]{3}[0-9]{3}$" <<< $1 1>/dev/null 2>&1
    then
      echo "$1 is valid"
  else
    echo "\"$1\" is not valid"
	VA=$[$VA+1]
  fi
}

# global variable for return a error message when a string is non-"nsid"
VA="0"

# checking if input as a file
if [ -f $1 ]
  then
    COUNT="1"
	# length of file
    END=`wc -l $1 | cut -f 8 -d " "`
	# loop til end of file
    while [[ $COUNT -le $END ]]
    do
		# get one line from file
        NSID=`cat $1 | head -$COUNT | tail -1`
		# if is a empty line, ignore it
        if [ "$NSID" == "" ]
            then
                COUNT=$[$COUNT+1]
        else
			# count number of string on that line
        	NOS=`echo $NSID | awk '{print NF}'`
        	NOS=$[$NOS+2]
        	START="1"
			# use temp file for further awk
        	echo $NSID > temp.txt
        	while [[ $START -le $NOS ]]
        	do
				# get specific string from line
            	TEMP=`awk -v a="$START" '{print $a}' temp.txt`
				# if it`s empty, ignore it
            	if [ "$TEMP" == "" ]
            		then
                		START=$[$START+1]
        		else
				# check if it is a "nsid" fromat
            	is_nsid $TEMP
            	START=$[$START+1] 
            	fi  	
        	done
        	COUNT=$[$COUNT+1]
        fi
    done
	#remove temp file
	rm -f temp.txt
	# check if any string inside file is non-valid; if so, return error meaasge
	if [ $VA -gt 0 ]
		then
			exit 1
	else
		exit 0
	fi
else
	# cut input string to piece
    NOS=`echo $1 | awk '{print NF}'`
    NOS=$[$NOS+2]
    START="1"
	# use temp file for further awk
    echo $1 > temp.txt
    while [[ $START -le $NOS ]]
    do
		# get specific string from line
        TEMP=`awk -v a="$START" '{print $a}' temp.txt`
		# if it`s empty, ignore it
        if [ "$TEMP" == "" ]
            then
				START=$[$START+1]
        else
			# check if it is a "nsid" fromat
            is_nsid $TEMP
            START=$[$START+1] 
        fi  	
    done
	# check if any string inside file is non-valid; if so, return error meaasge
	if [ $VA -gt 0 ]
		then
			exit 1
	else
		exit 0
	fi	
fi
