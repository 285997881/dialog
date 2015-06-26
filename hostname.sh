d: msgbox,v 1.3 2003/08/15 19:40:37 tom Exp $
: ${DIALOG=dialog}

hos=`uname -n`
ntpser=""
sshno=""

exec 3>&1

show=`$DIALOG --ok-label "Submit" \
          --backtitle "$backtitle" \
          --form "Here is a possible piece of a configuration program." \
20 50 0 \
        "Hostname:" 	1 1 	"$hos" 	1 12 16 0 \
	"Ntpserver:"	2 1	"$ntpser" 	2 12 16 0 \
	"Ssh(node2)"	3 1	"$sshno"	3 12 16 0 \
2>&1 1>&3`
retval=$?
exec 3>&-

value=`echo "$show"|awk 'BEGIN{ORS="#"}{print $0}'|sed -e 's/#$//'`

hostn=`echo $value|awk -F'#' '{print $1}'`
ntpserv=`echo $value|awk -F'#' '{print $2}'`
sshnode=`echo $value|awk -F'#' '{print $3}'`

case $retval in 
	0)
###########
# change hostname
###########
		if [ "$hostn" != `uname -n` ] ; then
			 hostname $hostn
			sed -i "s/HOSTNAME=.*/HOSTNAME=$hostn/" /etc/sysconfig/network
			ipaddr=`ifconfig eth0|grep 'inet addr'|awk -F ":" '{print $2}'|awk '{print $1}'`
			echo $ipaddr     $hostn >> /etc/hosts
		fi
#############
##time sync
#############
		if [ -n "$ntpserv"  ] ; then
			ntpdate $ntpserv
			if [ 0 -ne $? ] ; then
				$DIALOG --title "message box" --clear \
					--msgbox "time don't sync" 10 40
			fi
		fi
			
#############
##ssh communication
#############
		if [ -n "$sshnode" ] ;then
			#have this node?
			ping -c 3 $sshnode >/dev/null 
			if [ $? -ne 0  ] ; then
				$DIALOG --title "message box" --clear \
					--msgbox "don't have this Node " 10 40
			fi
			if [ $? -eq 0  ] ; then
				echo $sshnode
				ssh-keygen -t dsa 
				if [ -e ~/.ssh/id_rsa.pub ] ;then
				scp -r ~/.ssh/id_rsa.pub $sshnode:/root/.ssh/authorized_keys
########
##write fqdn to /etc/hosts
#######
				localipaddr=`ifconfig eth0|grep 'inet addr'|awk -F ":" '{print $2}'|awk '{print $1}'`
				localhostname=`uname -n`
				ssh $sshnode "echo $localipaddr $localhostname >> /etc/hosts"

				ipaddr=`ssh $sshnode "ifconfig eth0"|grep 'inet addr'|awk -F ":" '{print $2}'|awk '{print $1}'`
				hostna=`ssh $sshnode "uname -n"`
				echo $ipaddr $hostna >> /etc/hosts
				ssh $sshnode "echo $ipaddr $hostna >> /etc/hosts"
				fi
			fi		
	
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
