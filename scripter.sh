#!/bin/sh

# Adds Proxy settings for the Pi
add_proxy_settings() {
  my_http_proxy="http://10.3.100.207:8080/"
  my_https_proxy="https://10.3.100.207:8080/"
  apt_http_line="Acquire::http::proxy $my_http_proxy;"
  apt_https_line="Acquire::https::proxy $my_https_proxy;"
  sudo echo "$apt_http_line\n$apt_https_line" > /etc/apt/apt.conf.d/10proxy;
  bash_http_proxy="export http_proxy=$my_http_proxy"
  bash_https_proxy="export https_proxy=$my_https_proxy"
  sudo echo "$bash_http_proxy\n$bash_https_proxy" >> ~/.bashrc
}

# Checkers 

# CMake checker
cmake_exists() {
  type cmake &> /dev/null;
}

# Git checker
git_exists() {
  type git &> /dev/null;
}


###################################################################
#                         Main Module                             #
###################################################################
if git_exists; then
  echo "Git already installed on system"
else
  sudo apt-get install -y git
fi

if cmake_exists; then
  echo "CMake already installed on system"
else
  sudo apt-get install -y cmake
fi
add_proxy_settings
