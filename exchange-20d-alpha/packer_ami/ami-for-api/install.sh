#!/bin/bash
sleep 10
chmod +x /home/ec2-user/bootstrap.sh
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_15.x | sudo -E bash -
sudo yum install -y nodejs
cd /home/ec2-user/api
npm install
sudo systemctl daemon-reload
sudo systemctl enable exchange_api
sudo systemctl start exchange_api
