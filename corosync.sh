#!/bin/sh
# $Id: editbox,v 1.6 2007/01/10 23:24:44 tom Exp $
: ${DIALOG=dialog}

prefile(){
input=`tempfile 2>/dev/null` || input=/tmp/input$$
output=`tempfile 2>/dev/null` || output=/tmp/test$$
trap "rm -f $input $output" 0 1 2 5 15

tr=-e /etc/corosync/corosync.conf
echo $tr

if  [ ! -e /etc/corosync/corosync.conf ] ; then
	
         cp /etc/corosync/corosync.conf.example /etc/corosync/corosync.conf
fi
if [ -e /etc/corosync/corosync.conf ] ; then	
	echo "backup corosync.conf(yes/no)"
	read inp
		case $inp in
		yes|y|YES)
			cp /etc/corosync/corosync.conf /etc/corosync/corosync.conf.bak
		;;
		no|*)
		continue
		;;
		esac
	
fi

input=/etc/corosync/corosync.conf

$DIALOG --title "edit corosync.conf" \
	--fixed-font --editbox $input 0 0 2>$output

case $? in
  0)
    cat $output > /etc/corosync/corosync.conf
    echo "OK"
    ;;
  1)
    echo "Button 1 (Cancel) pressed";;
  255)
    echo "ESC pressed.";;
esac
}

rpm -qa | grep corosync > /etc/null

case $? in
	0)
		echo "corosync has install "
	;;
	*)
		echo "installing corosync"
		yum install -y corosync > /dev/null
	;;
esac

prefile
