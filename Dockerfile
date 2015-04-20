FROM geraldus/wheezy-haskell-base:latest

MAINTAINER Geraldus <heraldhoi@gmail.com>


# Emacs installation
RUN echo deb http://http.debian.net/debian wheezy-backports main >> \
    /etc/apt/sources.list
RUN apt-get update

RUN apt-get -t wheezy-backports install "emacs24-nox" -y --no-install-recommends

# init file

# ghci-ng installation

# haskell-flycheck



CMD emacs24-nox
