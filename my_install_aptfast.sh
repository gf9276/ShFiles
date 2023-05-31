#!/bin/bash

# 我就是单纯的懒。。。直接写在这里算了

set -o errexit # 报错直接退出


add-apt-repository ppa:apt-fast/stable
apt-get install apt-fast -y