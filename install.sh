#!/bin/bash
apt update -y && apt upgrade -y && apt autoremove -y

#Prerequisites
sudo apt-get install -y build-essential

openssl rand -hex 32 | sudo tee /var/lib/jwtsecret/jwt.hex > /dev/null



#Golang
cd ~
curl -LO https://go.dev/dl/go1.19.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
source $HOME/.profile
rm go1.19.linux-amd64.tar.gz

#Erigon
cd ~
curl -LO https://github.com/ledgerwatch/erigon/archive/refs/tags/v2022.09.02.tar.gz
tar xvf v2022.09.02.tar.gz
cd erigon-2022.09.02
make erigon
cd ~
sudo cp -a erigon-2022.09.02 /usr/local/bin/erigon
rm v2022.09.02.tar.gz
rm -r erigon-2022.09.01
sudo useradd --no-create-home --shell /bin/false erigon
sudo mkdir -p /var/lib/erigon
sudo chown -R erigon:erigon /var/lib/erigon

echo "[Unit]
Description=Erigon Execution Client (Ethereum Main Network)
After=network.target
Wants=network.target
[Service]
User=erigon
Group=erigon
Type=simple
Restart=always
RestartSec=5
ExecStart=/usr/local/bin/erigon/build/bin/erigon \
  --datadir=/var/lib/erigon \
  --http.api=engine,eth,net \
  --rpc.gascap=50000000 \
  --http \
  --ws \
  --rpc.batch.concurrency=100 \
  --state.cache=2000000 \
  --http.addr="0.0.0.0" \
  --http.port=8545 \
  --http.api="eth,erigon,web3,net,debug,trace,txpool" \
  --private.api.addr="0.0.0.0:9595" \
  --http.corsdomain="*" \
  --torrent.download.rate 90m \
  --authrpc.jwtsecret=/var/lib/jwtsecret/jwt.hex \
  --private.api.addr= \
  --metrics 
[Install]
WantedBy=default.target" >> /etc/systemd/system/erigon.service \


sudo systemctl daemon-reload
sudo systemctl start erigon
