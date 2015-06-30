#!/bin/bash
#
#presvn

presvn(){
echo "svn need wget gcc-c++ make unzip perl*"

rpm -qa | grep wget &> /etc/null
while [ $? -ne 0  ] ; 
do
	echo "you don't have wget,do you install(y|n):"
	read a
	case $a in
		y|Y) yum install -y wget &> /etc/null
		     echo "you have installed"
			 ;;
		n|N) continue 0  ;;
	esac 
done
 

rpm -qa | grep gcc-c++ &>/etc/null
while [ $? -ne 0  ] ; 
do
	echo "you don't have gcc-c++,do you install(y|n):"
	read a
	case $a in
		y|Y) yum install -y gcc-c++ &> /etc/null
		     echo "you have installed"
			 ;;
		n|N) continue 0 ;;
	esac 
done



rpm -qa | grep make &>/etc/null
while [ $? -ne 0  ] ; 
do
	echo "you don't have make,do you install(y|n):"
	read a
	case $a in
		y|Y) yum install -y make &> /etc/null
		     echo "you have installed"
			 ;;
		n|N) continue 0 ;;
	esac 
done



rpm -qa | grep unzip &> /etc/null
while [ $? -ne 0  ] ; 
do
	echo "you don't have unzip,do you install(y|n):"
	read a
	case $a in
		y|Y) yum install -y unzip &> /etc/null
		     echo "you have installed"
			 ;;
		n|N) continue 0 ;;
	esac 
done



rpm -qa | grep perl* &> /etc/null
while [ $? -ne 0  ] ; 
do
	echo "you don't have perl*,do you install(y|n):"
	read a
	case $a in
		y|Y) yum install -y perl* &> /etc/null
		     echo "you have installed"
			 ;;
		n|N) continue 0 ;;
	esac 
done
}

presvn

echo "then, install subversion"
yum install -y subversion &> /etc/null

rpm -qa |grep subversion&>/etc/null && echo "you have installed subversion"

echo "svn已经安装完成。该进行一些基本的配置了"
echo "输入你想将文件存储的目录："
read svndir

if [ -d $svndir  ]
then
	echo "要建的文件夹存在，还要建立吗？(y|n)"
	read a
	case $a in
		y|Y) mkdir -p $svndir ;;
		n|N) echo "请重新输入文件夹："
		     read svndir
		     continue ;;
	esac
elif [ ! -d $svndir  ]
then
	mkdir -p $svndir
fi

echo "需在$svndir下建一个文件夹作为版本仓库，输入它的名称:"
read repo
if [ -d $svndir/$repo  ]
then
        echo "要建的文件夹存在，还要建立吗？(y|n)"
        read a
        case $a in
                y|Y) mkdir -p $svndir/$repo 
                   ;;
	
	        n|N) echo "请重新输入文件夹："
                     read repo
                     continue ;;
        esac
elif [ ! -d $svndir/$repo  ]
then
        mkdir -p $svndir/$repo
      
fi

 
echo "将$svndir/$repo建为版本仓库"
svnadmin create $svndir/$repo

if [ $? -ne 0  ]
then
    	echo "此文件夹有问题，请重新输入一个："
       	./svn
fi

echo "下面建立个临时目录，以供svn使用"
echo "输入临时目录："
read tmpdir
mkdir -p  $tmpdir $tmpdir/branches $tmpdir/tags $tmpdir/trunk

echo "导入上面的项目"
svn import $tmpdir file:///$svndir/$repo --message "初始化项目目录"

echo "要查看一下你的项目目录吗(y|n)"
read a
case $a in
	y|Y) svn list --verbose file:///$svndir/$repo ;;
	n|N) exit ;;
esac

echo "可以通过 svnlook info $svndir/$repo 查看最新版本信息"
echo "通过 svnlook tree $svndir/$repo --show-ids 查看版本库的树形结构"

read a
