#!/usr/bin/env bash
set -x
RAILS_ENV=production ~/deployer/bin/rails db:migrate && RAILS_ENV=production ~/deployer/bin/rails s -d