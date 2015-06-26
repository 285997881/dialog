#!/bin/sh 

: ${DIALOG=dialog}

exec 3>&1

node2=`$DIALOG --inputbox "node2" 16 30  2>&1 1>&3`

value=`$DIALOG --ok-label "Submit" \
	  --checklist "which pacage you want install" \
20 50 10  \
	pacemaker	"pacemaker"	on \
	corosync	"corosync"     	on \
	crm		"crm"		on \
	pcs		"pcs"     	off \
	heartbeat	"heartbeat"	off \
	drbd		"drbd"		off \
2>&1 1>&3`
returncode=$?
exec 3>&-



if [ -n "$value" ] ; then
	list=`echo $value|sed "s/\"//g"`
#	yum install -y  $list >/dev/null
#	ssh $node2 "yum install -y  $list" >/dev/null
	
	crm=`echo $list | grep crm`
	if [ -n "$crm"  ] ; then
		exec 3>&1
		node2=`$DIALOG --inputbox "go to http://download.opensuse.org/repositories/network:/ha-clustering:/Stable/  download crm,gave address" 15 80 2>&1 1>&3`
		if [ -n "node2"  ] ; then
			wget $node2
			if [ $? -eq 0 ] ; then 
				yum install -y python-dateutil python-lxml > /dev/null
				rpm -ivh $node2
	fi
fi
