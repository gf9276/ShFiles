#!/bin/sh

hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
wslip=$(hostname -I | awk '{print $1}')
port=7890
socks_port=7890 # 看clash的配置，混合模式默认用的确实是7890

PROXY_HTTP="http://${hostip}:${port}"          # 我的建议是直接全部都用这个，少点bug，我说实话
PROXY_SOCKS="socks5://${hostip}:${socks_port}" # 别用socks5h

set_proxy() {
  export all_proxy="${PROXY_HTTP}" # http永远是最稳的，草
  export ALL_PROXY="${PROXY_HTTP}"
  export https_proxy="${PROXY_HTTP}"
  export HTTPS_PROXY="${PROXY_HTTP}"
  export http_proxy="${PROXY_HTTP}"
  export HTTP_PROXY="${PROXY_HTTP}"
  export no_proxy="localhost, 127.0.0.0/8, ::1, ${hostip}, ${wslip}"
  export NO_PROXY="localhost, 127.0.0.0/8, ::1, ${hostip}, ${wslip}"

  git config --global http.https://github.com.proxy ${PROXY_HTTP}
  git config --global https.https://github.com.proxy ${PROXY_HTTP}

  # 暂时注释掉，不然随着profile启动，会导致一些问题，启动的时候最好不要输出东西
  # echo "Proxy has been opened."
}

unset_proxy() {
  unset ALL_PROXY
  unset all_proxy
  unset HTTPS_PROXY
  unset https_proxy
  unset HTTP_PROXY
  unset http_proxy
  unset NO_PROXY
  unset no_proxy

  git config --global --unset http.https://github.com.proxy
  git config --global --unset https.https://github.com.proxy

  echo "Proxy has been closed."
}

test_setting() {
  echo "Host IP:" ${hostip}
  echo "WSL IP:" ${wslip}
  echo "Try to connect to Google..."
  resp=$(curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
  if [ ${resp} = 200 ]; then
    echo "Proxy setup succeeded!"
  else
    echo "Proxy setup failed!"
    echo "反正都没用, 帮你关上"
    unset_proxy
  fi
}

v1=${1:-"set"} # 设置默认为set，即开启
if [ "$v1" = "set" ]; then
  set_proxy

elif [ "$v1" = "unset" ]; then
  unset_proxy

elif [ "$v1" = "test" ]; then
  test_setting
else
  echo "Unsupported arguments."
fi
