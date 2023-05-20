#!/bin/bash

set -o errexit # 报错直接退出

echo -e "\e[36msudo会使代理失效, 建议以root用户的身份开启代理后再执行\e[0m"
echo -e "\e[36m开始更新、安装、设置语言\e[0m"

# 更新、安装fcitx和cjk、生成机器码
apt -y update
apt -y install fcitx fonts-noto-cjk fonts-noto-color-emoji dbus-x11 fcitx-googlepinyin
dbus-uuidgen >/var/lib/dbus/machine-id

# 检查文件是否存在，这个文件只能是我自己写的
if [ -e "/etc/profile.d/my_fcitx.sh" ]; then # 存在就删掉吧，重新来
    rm -f /etc/profile.d/my_fcitx.sh
fi

# 写入环境变量
echo '#!/bin/bash' >>/etc/profile.d/my_fcitx.sh
echo '' >>/etc/profile.d/my_fcitx.sh
echo '# 设置默认输入方式' >>/etc/profile.d/my_fcitx.sh
echo 'export QT_IM_MODULE=fcitx' >>/etc/profile.d/my_fcitx.sh
echo 'export GTK_IM_MODULE=fcitx' >>/etc/profile.d/my_fcitx.sh
echo 'export XMODIFIERS=@im=fcitx' >>/etc/profile.d/my_fcitx.sh
echo 'export DefaultIMModule=fcitx' >>/etc/profile.d/my_fcitx.sh
echo '' >>/etc/profile.d/my_fcitx.sh
echo '# fcitx自启动' >>/etc/profile.d/my_fcitx.sh
echo 'fcitx-autostart &>/dev/null' >>/etc/profile.d/my_fcitx.sh

echo ""
echo -e "\e[36m安装结束, wsl --shutdown 后重启wsl\e[0m"
echo -e "\e[36m重启后请执行 \e[93mfcitx-configtool  \e[36m手动设置快捷键\e[0m"
