#!/bin/zsh

function set_cli_proxy() {
  if [[ $(export | grep -c '_proxy') -lt 2 ]]; then
    export http_proxy=$HTTP_PROXY_ADDR
    export https_proxy=$HTTP_PROXY_ADDR
    echo "set cli proxy to \"$HTTP_PROXY_ADDR\""
    echo "1" > $HOME/workspace/auto-work/function/proxy_flag
  else
    echo "cli proxy has already set"
  fi
}

function unset_cli_proxy() {
  if [[ $(export | grep -c '_proxy') -ne 0 ]]; then
    unset http_proxy
    unset https_proxy
    echo "unset cli proxy"
    echo "0" > $HOME/workspace/auto-work/function/proxy_flag
  else
    echo "cli proxy has already unset"
  fi
}

function set_npm_proxy() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy == '' ]]; then
    echo "proxy=$HTTP_PROXY_ADDR" >>"$HOME/.npmrc"
    echo "https-proxy=$HTTP_PROXY_ADDR" >>"$HOME/.npmrc"
    echo "set npm proxy to \"$HTTP_PROXY_ADDR\""
  else
    echo "npm proxy has already set"
  fi
}

function unset_npm_proxy() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy =~ 'http' ]]; then
    sed -ie '/^proxy/d' "$HOME/.npmrc"
    sed -ie '/^https-proxy/d' "$HOME/.npmrc"
    echo "unset npm proxy"
  else
    echo "npm proxy has already unset"
  fi
}


function set_git_proxy() {
  if [ ! $(git config --get http.proxy) ]; then
    git config --global http.proxy $HTTP_PROXY_ADDR
    git config --global https.proxy $HTTP_PROXY_ADDR
    echo "set git proxy to \"$HTTP_PROXY_ADDR\""
  else
    echo "git proxy has already set"
  fi
}

function unset_git_proxy() {
  if [ $(git config --get http.proxy) ]; then
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    echo "unset git proxy"
  else
    echo "git proxy has already unset"
  fi
}

function proxy() {

  set_cli_proxy

  set_git_proxy

  set_npm_proxy
}

function unproxy() {

  unset_cli_proxy

  unset_git_proxy

  unset_npm_proxy
}

# 修正： 当set cli proxy后，重新打开terminal不会自动设置proxy
if [ $(cat $HOME/workspace/auto-work/function/proxy_flag) -eq "1" ];then
  proxy
else
  unproxy
fi

