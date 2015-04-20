FROM geraldus/wheezy-haskell-base:latest

MAINTAINER Geraldus <heraldhoi@gmail.com>


# Emacs installation
RUN echo deb http://http.debian.net/debian wheezy-backports main >> \
    /etc/apt/sources.list
RUN apt-get update

RUN apt-get -t wheezy-backports install "emacs24-nox" -y --no-install-recommends

# init file
WORKDIR /root
RUN mkdir /root/.emacs.d/
RUN git clone https://github.com/geraldus/emacs-docker.git \
 && cd emacs-docker \
 && cp init.el /root/.emacs.d/init.el

# Stylish Haskell and Hlint installations
RUN cabal update \
 && cabal install alex happy hlint stylish-haskell

# SHM
RUN git clone https://github.com/chrisdone/structured-haskell-mode.git \
 && cd structured-haskell-mode \
 && cabal install \
 && cd elisp \
 && make

# ghci-ng installation
RUN apt-get install libtinfo-dev -y --no-install-recommends
RUN git clone https://github.com/chrisdone/ghci-ng.git \
 && cabal install ghci-ng/ \
 && ghci-ng --version

# haskell-flycheck
RUN git clone https://github.com/chrisdone/haskell-flycheck.git \
 && cp haskell-flycheck/haskell-flycheck.el /etc/emacs24

# Cleanup
RUN rm -fr haskell-flycheck \
 && rm -fr ghci-ng

WORKDIR /

CMD emacs24-nox
