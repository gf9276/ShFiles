#!/bin/sh

# 该文件用于建立win和wsl之间的代理通信，请使用 source 运行

hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
wslip=$(hostname -I | awk '{print $1}')
port=7890
socks_port=7890 # clash的混合端口是7890，这个看clash而不是代理的配置，不是7891

PROXY_HTTP="http://${hostip}:${port}"
PROXY_SOCKS="socks5h://${hostip}:${socks_port}"

set_proxy(){
  export all_proxy="${PROXY_SOCKS}"
  export ALL_PROXY="${PROXY_SOCKS}"
  export https_proxy="${PROXY_HTTP}"
  export HTTPS_PROXY="${PROXY_HTTP}"
  export http_proxy="${PROXY_HTTP}"
  export HTTP_PROXY="${PROXY_HTTP}"
  export no_proxy="localhost,127.0.0.1,${hostip},${wslip}"

  git config --global http.https://github.com.proxy ${PROXY_SOCKS}
  git config --global https.https://github.com.proxy ${PROXY_SOCKS}

  echo "Proxy has been opened."
}

unset_proxy(){
  unset ALL_PROXY
  unset all_proxy
  unset HTTPS_PROXY
  unset https_proxy
  unset HTTP_PROXY
  unset http_proxy

  git config --global --unset http.https://github.com.proxy
  git config --global --unset https.https://github.com.proxy

  echo "Proxy has been closed."
}

test_setting(){
  echo "Host IP:" ${hostip}
  echo "WSL IP:" ${wslip}
  echo "Try to connect to Google..."
  resp=$(curl -I -s --connect-timeout 5 -m 5 -w "%{http_code}" -o /dev/null www.google.com)
  if [ ${resp} = 200 ]; then
    echo "Proxy setup succeeded!"
  else
    echo "Proxy setup failed!"
  fi
}

if [ "$1" = "set" ]
then
  set_proxy

elif [ "$1" = "unset" ]
then
  unset_proxy

elif [ "$1" = "test" ]
then
  test_setting
else
  echo "Unsupported arguments."
fi
