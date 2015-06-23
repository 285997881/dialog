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
 	"1 Device name:"        1 1     "$dev"          1  16 25 15 \
	"2 On boot:"            2 1     "$on_boot"      2  16 25 15 \
 	"3 DHCP:"               3 1     "$boot_dhcp"    3  16 25 15 \
 	"4 Ip address:"         4 1     "$ipaddr"       4  16 25 15 \
 	"5 Netmask:"            5 1     "$netmask"      5  16 25 15 \
 	"6 Broadcast:"          6 1     "$broadcast"    6  16 25 15 \
 	"7 Gateway:"            7 1     "$gateway"      7  16 25 15 \
2>&1 1>&3`
return=$?
exec 3>&-
