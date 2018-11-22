#!/usr/bin/env bash
path="/home/hrmtadm/vm-portal"
cd $path && \
pwd && \
git --version && \
$path/bin/rails --version && \
git -C $path ls-remote --get-url && \
git -C $path pull && \
BUNDLE_GEMFILE=$path/Gemfile $path/bin/bundle install && \
BUNDLE_GEMFILE=$path/Gemfile $path/bin/bundle exec mina staging deploy -s
