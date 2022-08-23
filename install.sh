#!/bin/bash
apt update -y && apt upgrade -y && apt autoremove -y

#Prerequisites
sudo apt-get install -y build-essential supervisor wget git




#Golang
wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go

sudo useradd -m -s /bin/bash erigon

cd /opt
sudo mkdir erigon
sudo mkdir github && cd github
sudo git clone https://github.com/ledgerwatch/erigon.git
cd erigon
git checkout v2022.08.02
sudo make
sudo cp -r ./build/bin /opt/erigon/
sudo mkdir -p /data/erigon/datadir
sudo chown -R erigon:erigon /data/erigon

echo  "[program:erigon]
command=bash -c '/opt/erigon/bin/erigon --datadir="/data/erigon/datadir" --rpc.gascap=50000000 --rpc.batch.concurrency=100 --http.addr="0.0.0.0" --http.port=8545 --private.api.addr="0.0.0.0:9595" --http.corsdomain="*" --http.api="eth,erigon,web3,net,debug,trace,txpool" --torrent.download.rate 90m --state.cache=2000000 --http --ws --metrics'
user=erigon
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/erigon.err.log
stderr_logfile_maxbytes=1000000
stderr_logfile_backups=10
stdout_logfile=/var/log/supervisor/erigon.out.log
stdout_logfile_maxbytes=1000000
stdout_logfile_backups=10
stopwaitsecs=300
" >> /etc/supervisor/conf.d/erigon.conf \

sudo systemctl enable supervisor
sudo systemctl start supervisor
sudo supervisorctl update
sleep 5
supervisorctl status erigon
