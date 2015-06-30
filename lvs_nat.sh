#!/bin/bash
#
echo "以下是配置lvs NAT的过程"
echo "首先需开启ip转发功能，将/proc/sys/net/ipv4/ip_forward的值改为1"
echo "现在ip_forword的值是："`cat /proc/sys/net/ipv4/ip_forward`
echo "修改ip_forward的值吗(y|n)"
read answer
case $answer in
        y|Y) echo 1 > /proc/sys/net/ipv4/ip_forward ;;
        n|N|*) echo "你没有修改ip_forward的值";;
esac

echo "下面安装ipvsadm,直接用yum安装"
yum -y install ipvsadm

rpm -qa | grep ipvsadm

if [ $? -ne 0  ]
then
        echo "ipvsadm安装没有成功，请检查你的相关配置，以便重新安装"
        echo "是否要重新安装ipvsadm(y|n)"
        read answer
        case $answer in
                y|Y) yum -y install ipvsadm
                     continue
                ;;
                n|N|*)echo "你没有安装ipvsadm!"
                ;;
        esac
else
   echo "ipvsadm已经安装成功"
fi


echo "下面管理集群规则，要管理吗(y|n)"
read answer
while [ $answer=y ] ; do
        echo "添加一个新规则(a|A),编辑一个规则(e|E)还是要删除规则(d|D)"
        read answer
        echo "指定规则的协议，t表示tcp，u表示udp，f是firewall-mark"
        read pro
        echo "指定主机ip,格式为ip:port"
        read hostip
        echo "指定调度算法：Fixed:RR,WRR,DH,SH Dynamic:LC,WLC,SED,NQ,LBLC,LBLCR"
        read sche
        answer=`echo $answer |tr a-z A-Z`
        pro=`echo $pro |tr A-Z a-z`
        sche=`echo $sche |tr A-Z a-z`

        if [ $answer = D  ] ; then
                ipvsadm -$answer -$pro $hostip
        elif [ $answer = A ] || [ $answer = E  ] ; then
                ipvsadm -$answer -$pro $hostip -s $sche

        else echo "输入有问题"
        fi

        echo "继续添加规则吗(y|n)"
        read answer
done

while [ $answer != y ] ; do  echo "没有修改规则" ;break; done


echo "下面管理real server规则，要管理吗(y|n)"
read answer
while [ $answer = y ] ;do
        echo "添加一个新规则(a|A),编辑一个规则(e|E)还是要删除规则(d|D)"
        read answer
        echo "指定规则的协议，t表示tcp，u表示udp，f是firewall-mark"
        read pro
        echo "指定real server主机ip,格式为ip:port"
        read realip
        echo "指定direct server主机ip,格式为ip"
        read dirip
        echo "指定使用的模型：NAT(m),DR(g) TUN(i)"
        read sche
        answer=`echo $answer |tr A-Z a-z`
        pro=`echo $pro |tr A-Z a-z`
        sche=`echo $sche |tr A-Z a-z`

        if [ $answer = D  ] ; then
                echo "ipvsadm -$answer -$pro $realip -r $dirip"
        elif [ $answer = a  ] || [ $answer = e  ] ; then
                echo "ipvsadm -$answer -$pro $realip -r $dirip -$sche"
        else echo "输入有问题"
        fi

        echo "继续添加规则吗(y|n)"
        read answer
done

while [ $answer != y ] ; do  echo "没有修改规则" ;break; done

echo "规则已经添加完成"
echo "可以用service ipvsadm save 保存规则"
echo "ipvsadm -L -n -c (用于查看定义的规则)"
echo "ipvsadm -C (用于清空规则)"
