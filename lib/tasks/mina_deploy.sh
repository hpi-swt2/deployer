#!/usr/bin/env bash
cd /home/hrmtadm/vm-portal && \
pwd && \
git --version && \
rails --version && \
git ls-remote --get-url && \
git pull && \
BUNDLE_GEMFILE=/home/hrmtadm/vm-portal/Gemfile /home/hrmtadm/vm-portal/bin/bundle install && \
pwd && \
BUNDLE_GEMFILE=/home/hrmtadm/vm-portal/Gemfile /home/hrmtadm/vm-portal/bin/bundle/bin exec mina staging deploy -s