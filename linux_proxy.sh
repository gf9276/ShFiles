#!/bin/sh

if [ ! $hostip ]; then
  hostip=127.0.0.1 # 如果没有环境变量，就给一个，如果有环境变量，自然就用现成的
fi

port=7890
socks_port=7890 # 看clash的配置，有时候混合模式默认用的确实是7890

set_proxy() {
  PROXY_HTTP="http://${hostip}:${port}"          # 我的建议是直接全部都用这个，少点bug，我说实话
  PROXY_SOCKS="socks5://${hostip}:${socks_port}" # 别用socks5h！！！

  export all_proxy="${PROXY_HTTP}" # http永远是最稳的，草
  export ALL_PROXY="${PROXY_HTTP}"
  export https_proxy="${PROXY_HTTP}"
  export HTTPS_PROXY="${PROXY_HTTP}"
  export http_proxy="${PROXY_HTTP}"
  export HTTP_PROXY="${PROXY_HTTP}"
  export no_proxy="localhost, 127.0.0.0/8, ::1, ${hostip}"
  export NO_PROXY="localhost, 127.0.0.0/8, ::1, ${hostip}"

  conda config --set proxy_servers.http ${PROXY_HTTP}
  conda config --set proxy_servers.https ${PROXY_HTTP}

  git config --global http.https://github.com.proxy ${PROXY_HTTP}
  git config --global https.https://github.com.proxy ${PROXY_HTTP}

  # 我现在用的是docker，不用这个了，不好用
  # setsid ~/clash/clash
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

  conda config --remove-key proxy_servers
  conda config --remove-key proxy_servers

  git config --global --unset http.https://github.com.proxy
  git config --global --unset https.https://github.com.proxy

  echo "Proxy has been closed."
  # echo "输入ps -ef | grep clash，并干掉对应的进程"
}

test_setting() {
  echo "Host IP:" ${hostip}
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
v2=${2:-""}    # 第二个位置是ip
if [ "$v1" = "set" ]; then
  if [ ! "$v2" = "" ]; then
    hostip="$v2" # 如果给了ip，就更新ip
  fi
  set_proxy

elif [ "$v1" = "unset" ]; then
  unset_proxy

elif [ "$v1" = "test" ]; then
  test_setting
else
  echo "Unsupported arguments."
fi
