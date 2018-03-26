#!/bin/bash
set -e

# Deploy Ruby application
git clone -b monolith https://github.com/express42/reddit.git 
cd reddit && bundle install
puma -d

