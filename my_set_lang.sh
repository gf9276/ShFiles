#!/bin/bash

# 该文件用于设置用户语言 使用sudo ./的方式执行

set -o errexit # 报错直接退出

echo -e "\e[36m开始更新、安装、设置语言\e[0m"
apt -y update

apt -y install locales

echo ""
echo -e "\e[36m接下来将进行时区配置，你将会看到两个界面\e[0m"
echo -e "\e[36m第一个界面是让挑选你想要安装的语言包, 然后第二个界面才是让你在你系统里已安装的语言包里选一个作为你平时使用的\e[0m"
echo -e "\e[36m第一个界面你可以全选, 但没必要, 用不上, 如果平时用的中英文, 选择 \e[93men_US.UTF-8, zh_CN.GBK, zh_CH.UTF-8\e[0m"
echo -e "\e[36m第二个界面是选择默认的语言, 中文选择 \e[93mzh_CH.UTF-8, \e[36m英文选择 \e[93men_US.UTF-8, \e[36m系统一开始默认的应该是 \e[93mC.UTF-8\e[0m"



echo -en "\n\e[36m是否明白\e[93m(yes/no):\e[0m"
read choice

if [ "$choice" != "yes" ]
then
    echo -e "\e[36m不是yes, 退出\e[0m"
    exit
fi

sudo dpkg-reconfigure locales

echo -en "\n\e[36m是否需要中文字体和语言包\e[93m(yes/no):\e[0m"
read choice

if [ "$choice" == "yes" ]
then
    apt -y install ttf-wqy-microhei ttf-wqy-zenhei xfonts-intl-chinese

    # 注意, 这里不需要安装语言包, apt install language-pack-zh-hans, 因为这一步在前面的第一个界面已经做过了
fi

echo -e "\e[36m安装结束, 重新打开shell, 使用指令\e[93m locale \e[36m查看安装情况\e[0m"