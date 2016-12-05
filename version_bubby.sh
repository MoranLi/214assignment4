#!/bin/sh
# Author: Yukun Li
# NSID: yul040
# shell script used to change file name from *_*_*.* to *.*.*.*
# echo $? to get exit status

# check if input contain redirection
if egrep "/" <<< $1 1>/dev/null 2>1
  then
    echo "file must be in the current working directory"
    exit 2
# check if file name follow pattern required
elif egrep "^\S{1,}_\d_\d\.\S{1,}$" <<< $1 1>/dev/null 2>1
  then
    # check if file exist in current working space 
    if [ -f $1 ]
      then
	    # cut file name to piece for rename
        PA=`echo $1 | cut -f 1 -d '_'`
        PB=`echo $1 | cut -f 2 -d '_'`
        PC=`echo $1 | cut -f 3 -d '_' | cut -f 1 -d '.'`
        PD=`echo $1 | cut -f 2 -d '.'`
		  #check if same name file already exist
          if [ -f $PA.$PB.$PC.$PD ]
            then
              echo "destination file $PA.$PB.$PC.$PD already exists"
              exit 4
		  #if every thing is fun, rename
          else
            echo "$1 -> $PA.$PB.$PC.$PD"
            mv ./$1 ./$PA.$PB.$PC.$PD
          fi
    else
      echo "$1 must exist in the current working directory"
      exit 3
    fi
# other wrong case
else
  # no input file
  if [[ $1 == "" ]]
    then
      echo "usage: version_buddy <filename>"
      echo "  where <filename> is of the form Name_Major_Minor.Extension"
      echo "  and does not contain any whitespace"
      exit 1
  # double input file
  elif [[ $2 != "" ]]
    then
      echo "usage: version_buddy <filename>"
      echo "  where <filename> is of the form Name_Major_Minor.Extension"
      echo "  and does not contain any whitespace"
      exit 1
  # add option not supported by this shell function
  elif egrep '\-\S' <<< $1 1>/dev/null 2>1
    then
      echo "option $1 not recognized"
      echo "usage: version_buddy <filename>"
      echo "  where <filename> is of the form Name_Major_Minor.Extension"
      echo "  and does not contain any whitespace"
      exit 1
  # input file name not follow pattern
  else
    echo "filename is not well-formed"
    exit 2
  fi
fi

