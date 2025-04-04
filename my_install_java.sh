#!/bin/bash

# 该文件用于java的安装，可选版本8 17 11
# 测试过没有问题

set -o errexit # 报错直接退出

echo -e "\e[36msudo会使代理失效, 建议以root用户的身份开启代理后再执行\e[0m"
echo -e "\e[36m如果下载突然变慢, 可以 ctrl c 后再重来, 下载是可以接上的\e[0m"
echo -e "\e[36m开始更新、安装、设置 java\e[0m"

java_cfg_file_path="/etc/profile.d/my_java_cfg.sh" # 这个路径不能错, 必须在 /etc/profile.d/ 下面, 名字无所谓

# 版本筛选开始 ------------------------------
echo -en "\e[36m写入java版本, 需要多个版本以空格隔开\e[93m(8/11/17):\e[0m"
need_8=false
need_11=false
need_17=false

read -ra java_v_arr
for element in ${java_v_arr[*]}; do
    if [ "$element" == "8" ]; then
        need_8=true
    elif [ "$element" == "17" ]; then
        need_17=true
    elif [ "$element" == "11" ]; then
        need_11=true
    fi
done

if [ "$need_8" != "true" ] && [ "$need_11" != "true" ] && [ "$need_17" != "true" ]; then
    echo -e "\e[36m没有所需要的版本\e[0m"
    exit
fi

# 注意: 这里的顺序意味着写入配置的优先级
echo -en "\e[36m开始安装:\e[0m"
cfg_nbr=11
if [ "$need_8" == "true" ]; then
    echo -en "\e[93mjava8\e[0m "
    cfg_nbr=8
fi
if [ "$need_17" == "true" ]; then
    echo -en "\e[93mjava17\e[0m "
    cfg_nbr=17
fi
if [ "$need_11" == "true" ]; then
    echo -en "\e[93mjava11\e[0m "
    cfg_nbr=11
fi
echo ""
# 版本筛选结束 ------------------------------

# 安装过程 ------------------------------
apt -y update # 更新, 防止报错
if [ "$need_8" == "true" ]; then
    apt -y install openjdk-8-jdk
fi
if [ "$need_17" == "true" ]; then
    apt -y install openjdk-17-jdk
fi
if [ "$need_11" == "true" ]; then
    apt -y install openjdk-11-jdk
fi

echo ""
echo -e "\e[36m安装完成, 写入环境变量到:\e[93m$java_cfg_file_path\e[36m, 写入优先级11>17>8\e[0m"

if [ -e $java_cfg_file_path ]; then # 存在就删掉吧，重新来
    rm -f $java_cfg_file_path
fi

# 注意下面的单引号和双引号
echo "export JAVA_HOME=/usr/lib/jvm/java-$cfg_nbr-openjdk-amd64" >>$java_cfg_file_path

# 版本大于8，JRE集成到JDK里了
if [ "$cfg_nbr" -gt 8 ]; then
    echo 'export JRE_HOME=$JAVA_HOME' >>$java_cfg_file_path
else
    echo 'export JRE_HOME=$JAVA_HOME/jre' >>$java_cfg_file_path
fi
echo 'export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >>$java_cfg_file_path

echo -e "\e[36m环境变量写入完毕, 请检查文件以确保写入没有问题:\e[93msudo vim $java_cfg_file_path\e[0m"
echo -e "\e[36m请手动执行指令:\e[93msudo update-alternatives --config java \e[36m选择与环境变量对应版本一致的java\e[0m"

echo -e "\e[36m检查完后请手动执行命令:\e[93m. /etc/profile\e[0m\n"

# lf
