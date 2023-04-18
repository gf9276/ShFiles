#!/bin/bash

# 该文件用于maven的安装
# 测试过没有问题

set -o errexit # 报错直接退出

echo -e "\e[36msudo会使代理失效, 建议以root用户的身份开启代理后再执行\e[0m"
echo -e "\e[36m开始安装 maven 到 /opt/maven 目录下 \e[0m"

maven_cfg_file_path="/etc/profile.d/my_maven_cfg.sh"

# 下载压缩包
if [ ! -d "/opt/maven" ]  # 不存在
then # 创建这个目录
    mkdir /opt/maven
fi
cd /opt/maven

if [ ! -e "./apache-maven-3.9.1-bin.tar.gz" ]  # 不存在才下载
then # 下载压缩包
    wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz
fi

# 解压缩并删除压缩包
cd /opt/maven
tar -zxvf apache-maven-3.9.1-bin.tar.gz
rm apache-maven-3.9.1-bin.tar.gz

echo ""
echo -e "\e[36m安装完成, 写入环境变量到:\e[93m$maven_cfg_file_path\e[0m"

# 注意下面的单引号和双引号
echo 'export M2_HOME=/opt/maven/apache-maven-3.9.1' >> $maven_cfg_file_path
echo 'export MAVEN_HOME=$M2_HOME' >> $maven_cfg_file_path
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> $maven_cfg_file_path

echo -e "\e[36m请手动执行命令完成环境变量更新:\e[93m. /etc/profile\e[0m\n"