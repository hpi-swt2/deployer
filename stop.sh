#!/usr/bin/env bash
set -x
kill -15 $(cat ~/deployer/tmp/pids/server.pid)