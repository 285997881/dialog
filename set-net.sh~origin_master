#! /bin/sh
: ${DIALOG=dialog}

ipaddr=`ifconfig eth0|grep 'inet addr'|awk -F ":" '{print $2}'|awk '{print $1}'`
dev=`grep DEVICE < /etc/sysconfig/network-scripts/ifcfg-eth0 | awk -F '=' '{print $2}'`
boot_dhcp=`grep BOOTPROTO < /etc/sysconfig/network-scripts/ifcfg-eth0 | awk -F '=' '{print $2}'`
on_boot=`awk '/ONBOOT/' /etc/sysconfig/network-scripts/ifcfg-eth0 |awk -F '=' '{print $2}'`
broadcast=`ifconfig eth0|grep 'inet addr'|awk -F ":" '{print $3}'|awk '{print $1}'`
netmask=`ifconfig eth0|grep 'inet addr'|awk -F ":" '{print $4}'|awk '{print $1}'`
gateway=`awk '/GATEWAY/' /etc/sysconfig/network-scripts/ifcfg-eth0 |awk -F '=' '{print $2}'`

exec 3>&1
value=`$DIALOG --ok-label "Submit" \
	  --form "Here is a possible piece of a configuration program." \
0 0 10 \
 	"1 Device name:"        1 1     "$dev"          1  30 25 15 \
	"2 On boot(yes/no):"            2 1     "$on_boot"      2  30 25 15 \
 	"3 DHCP(dhcp/static/none):"               3 1     "$boot_dhcp"    3  30 25 15 \
 	"4 Ip address:"         4 1     "$ipaddr"       4  30 25 15 \
 	"5 Netmask:"            5 1     "$netmask"      5  30 25 15 \
 	"6 Broadcast:"          6 1     "$broadcast"    6  30 25 15 \
 	"7 Gateway:"            7 1     "$gateway"      7  30 25 15 \
2>&1 1>&3`
return=$?
exec 3>&-

device=`echo $value|awk '{print $1}'`
onboot=`echo $value|awk '{print $2}'`
dhcp=`echo $value|awk '{print $3}'`
ipaddr=`echo $value|awk '{print $4}'`
mask=`echo $value|awk '{print $5}'`
broad=`echo $value|awk '{print $6}'`
gatew=`echo $value|awk '{print $7}'`


if [ "$device" != "$dev" ] ;then
	sed -i "s/DEVICE.*/DEVICE=$device/" /etc/sysconfig/network-scripts/ifcfg-eth0
fi

if [ "$onboot" != "$on_boot" ] ;then
	sed -i "s/ONBOOT.*/ONBOOT=$onboot/" /etc/sysconfig/network-scripts/ifcfg-eth0
fi

if [ "$dhcp" != "dhcp"  ] ; then

	nae="IPADDR NETMASK GATEWAY BROADCAST"
	for  i in $nae ; do
       		 choose=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 |grep $i`
        	if [ -z $choose ] ; then
                	echo $i>> /etc/sysconfig/network-scripts/ifcfg-eth0
        	fi    
	 done
	
	sed -i "s/BOOTPROTO.*/BOOTPROTO=$dhcp/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/IPADDR.*/IPADDR=$ipaddr/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/NETMASK.*/NETMASK=$mask/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/BROADCAST.*/BROADCAST=$broad/" /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i "s/GATEWAY.*/GATEWAY=$gatew/" /etc/sysconfig/network-scripts/ifcfg-eth0
fi
