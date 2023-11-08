#!/bin/bash

# 该文件用于创建wsl到ubuntu的跨平台容器

# 查找libnvidia-ml.so.driver_version文件，并保存driver_version版本号
libnvidia_ml_file=$(find /usr/lib/x86_64-linux-gnu/ -name 'libnvidia-ml.so.*' | grep -v libnvidia-ml.so.1)
driver_version=${libnvidia_ml_file#/usr/lib/x86_64-linux-gnu/libnvidia-ml.so.}
echo "[success]:find GPU driver version=$driver_version"

# 删除libnvidia-ml.so.driver_version.1原本存在的软链接，并且新建软链接：libnvidia-ml.so.1.driver_version -> libnvidia-ml.so.1
rm -f /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
ln -s "$libnvidia_ml_file" /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1
echo "[success]:create ls: libnvidia-ml.so.1.$driver_version -> libnvidia-ml.so.1"

# 删除libcuda.so.driver_version原本存在的软链接，并且新建软链接：libcuda.so.1.driver_version -> libcuda.so.1
rm -f /usr/lib/x86_64-linux-gnu/libcuda.so.1
ln -s "/usr/lib/x86_64-linux-gnu/libcuda.so.1.$driver_version" /usr/lib/x86_64-linux-gnu/libcuda.so.1
echo "[success]:create ls: libcuda.so.1.$driver_version -> libcuda.so.1 -> libcuda.so"


# 下面是配套的Dockerfile
# FROM kosmos2_show:latest # 优先从docker image找，没有就从dockerhub找

# WORKDIR /app # 创建工作目录/app
# COPY ./createlink.sh . # 将本机的createlink.sh复制到镜像中的/app目录下，注意后面有个点，代表WORKDIR文件夹
# USER root # 切换root用户
# RUN cd /app && ./createlink.sh  # 进入 /app执行createlink.sh
# WORKDIR /home/user/app