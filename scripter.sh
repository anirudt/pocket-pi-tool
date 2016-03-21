#!/bin/bash

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

# Vim checker
vim_exists() {
  type vim &> /dev/null;
}

prepare_for_cv() {
  echo "Installing OpenCV dependencies .. .."
  sudo apt-get install -y build-essential;
  sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
  sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
  echo "Installed OpenCV dependencies."
}

install_cv() {
  git clone https://github.com/Itseez/opencv.git
  echo "OpenCV repository successfully cloned."
  echo "Make the release directory? Press (y/n)"
  read MAKE_RELEASE
  if [[ $MAKE_RELEASE == y ]]; then
    mkdir opencv/release; cd opencv/release;
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
    echo "Please proceed to build OpenCV."
  else
    echo "Configure using cmake separately."
  fi
}

display() {
  echo "*Welcome to the Rapberry Pi install portal*";
  echo "Press the sequence of numbers for the required tasks:";
  echo "a-> Update proxy settings";
  echo "b-> Install Git";
  echo "c-> Install Vim";
  echo "d-> Clone custom Git repository [BTP]";
  echo "f-> Install PiPan package"
  echo "g-> Install OpenCV Dependencies"
  echo "i-> Clone OpenCV repository & make release dir"
  echo "q-> Install CMake";
  echo "Usage:";
  echo "$ ./scripter.sh 123";
  echo "for running 1, 2, and 3.";
}

main() {
  options=$1
  if [[ "$options" == *a* ]]; then
    add_proxy_settings
    echo "Proxy settings successfully updated."
  fi
  if [[ "$options" == *b* ]]; then
    if git_exists; then
      echo "Git is already installed on system"
    else
      sudo apt-get install -y git
    fi
  fi
  if [[ "$options" == *c* ]]; then
    if vim_exists; then
      echo "Vim is already installed on system"
    else
      sudo apt-get install -y vim
    fi
  fi
  if [[ "$options" == *d* ]]; then
    if [ -d btp ]; then
      if [ -d btp/.git ]; then
        cd btp; git status;
        cd ../
      else
        # Do something here
        mkdir btp1; cd btp1;
        git clone https://anirudt_bit@bitbucket.org/anirudt_bit/btp.git;
        cd ../
      fi
    else
      git clone https://anirudt_bit@bitbucket.org/anirudt_bit/btp.git;
    fi
  fi
  if [[ "$options" == *f* ]]; then
    if [ -d btp/pi-pan ]; then
      cp -r btp/pi-pan/ pi-pan/
      cd btp/pi-pan/
      sudo ./install-pi-pan.bash;
      cd ../../
    else
      echo "PiPan not installed as part of BTP package, 
            please install BTP package first"
    fi
  fi
  if [[ "$options" == *g* ]]; then
    prepare_for_cv
  fi
  if [[ "$options" == *i* ]]; then
    install_cv
  fi
  if [[ "$options" == *q* ]]; then
    if cmake_exists; then
      echo "CMake is already installed on system"
    else
      sudo apt-get install -y cmake
    fi
  fi
  if [[ "$options" == *help* ]]; then
    display
  fi
}

###################################################################
#                         Main Module                             #
###################################################################
options=$1
main $options
