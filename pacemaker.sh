#!/bin/sh

rpm -qa | grep pacemaker > /etc/null

case $? in
	0)
		echo "pacemaker has install "
	;;
	*)
		echo "installing pacemaker"
		yum install -y pacemaker 
	;;
esac

