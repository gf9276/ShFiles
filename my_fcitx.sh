#!/bin/bash

# 设置默认输入方式
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx

# fcitx自启动
fcitx-autostart &>/dev/null
