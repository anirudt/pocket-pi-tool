#!/bin/sh

# Adds Proxy settings for the Pi
add_proxy_settings() {
  sudo :> /etc/apt/apt.conf.d/10proxy
  my_http_proxy="http://10.3.100.207:8080/"
  my_https_proxy="https://10.3.100.207:8080/"
}

# Git checker
git_exists() {
  type git &> /dev/null;
}


###################################################################
#                     Main Module                                 #
###################################################################
if git_exists; then
  echo "Git already installed on system"
else
  sudo apt-get install -y git
fi
