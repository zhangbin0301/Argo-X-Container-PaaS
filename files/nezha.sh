#!/usr/bin/env bash

# 检测是否已运行
check_run() {
  [[ $(pgrep -laf nezha-agent) ]] && echo "哪吒客户端正在运行中" && exit
}

# 三个变量不全则不安装哪吒客户端
check_variable() {
  [[ -z "${NEZHA_SERVER}" || -z "${NEZHA_PORT}" || -z "${NEZHA_KEY}" ]] && exit
}

# 下载最新版本 Nezha Agent
download_agent() {
  if [ ! -e nezha-agent ]; then
    URL=$(wget -qO- "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
    URL=${URL:-https://github.com/naiba/nezha/releases/download/v0.14.11/nezha-agent_linux_amd64.zip}
    wget ${URL}
    unzip -qod ./ nezha-agent_linux_amd64.zip
    rm -f nezha-agent_linux_amd64.zip
  fi
}

check_run
check_variable
download_agent
