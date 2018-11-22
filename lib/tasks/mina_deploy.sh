#!/usr/bin/env bash
cd /home/hrmtadm/vm-portal && \
pwd && \
git --version && \
rails --version && \
git ls-remote --get-url && \
git pull && \
bundle install && \
pwd && \
mina staging deploy -s