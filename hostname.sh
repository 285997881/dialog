d: msgbox,v 1.3 2003/08/15 19:40:37 tom Exp $
: ${DIALOG=dialog}

hos=`uname -n`

exec 3>&1

value=`$DIALOG --ok-label "Submit" \
          --backtitle "$backtitle" \
          --form "Here is a possible piece of a configuration program." \
20 50 0 \
        "Hostname:" 1 1 "$hos" 1 12 16 0 \
2>&1 1>&3`
retval=$?
exec 3>&-

echo $retval
case $retval in 
	0)
		if [ "$value" != `uname -n` ] ; then
			 hostname $value
			sed -i.bak "s/HOSTNAME=.*/HOSTNAME=$value/" /etc/sysconfig/network
			echo `hostname`
		fi
		;;
	1)
		/bin/sh basic.sh
	;;
	255)
		if test -n "$value" ; then
      		echo "$value"
    		else
      		echo "ESC pressed."
    		fi
    		;;
esac
