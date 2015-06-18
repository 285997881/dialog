#!/bin/sh

: ${DIALOG=dialog}

exec 3>&1
value=`$DIALOG  \
        --clear \
        --title "Select what you want :" \
        --menu \
"Please select  from the following list to use for your." 13 70 5 \
"1" "Hostname" \
"2" "Network" \
"3" "Ntp" \
"4" "Ssh_share" \
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
	echo "2";;
   3)
	echo "3";;
esac


#######################################################
#network
#######################################################
set_network()
{
	ip addr;
}
set_network
