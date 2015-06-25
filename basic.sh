#!/bin/sh

: ${DIALOG=dialog}

exec 3>&1
value=`$DIALOG  \
        --clear \
        --title "Select what you want :" \
        --menu \
"Please select  from the following list to use for your." 13 70 5 \
"1" "Hostname/Ntp/Ssh" \
"2" "Network" \
2>&1 1>&3`

retval=$?

exec 3>&-

case $retval in
  0)
    echo "$value chosen.";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -n "$value" ; then
      echo "$value"
    else
      echo "ESC pressed."
    fi
    ;;
esac

case $value in
   1)
	/bin/sh hostname.sh;;
   2)
	/bin/sh set-net.sh;;
   3)
	echo "3";;
esac


