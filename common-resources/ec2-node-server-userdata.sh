#!/bin/bash

sudo yum install -y gcc-c++ make;
curl -sL https://rpm.nodesource.com/setup_13.x | sudo -E bash -;

sudo yum install -y nodejs

mkdir code && cd code;

curl -H "Cache-Control: no-cache" https://gist.githubusercontent.com/solanoepalacio/61409de5f74c88c754ca1f1d044e81fa/raw/c25e4abbe9c3a79f682d24b75f1422558785da9f/server.js > server.js

echo "Server start command ran at: $(date)" >> logs

sudo node ./server.js >> logs