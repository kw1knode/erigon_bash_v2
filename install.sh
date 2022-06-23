#!/bin/bash

######################################################################################
#####################            DEPENDENCIES                  #######################
######################################################################################

apt update -y && apt upgrade -y && apt autoremove -y
sudo apt-get install -y build-essential supervisor wget git



#Install Golang
wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go

#Create Isolated User
sudo useradd -m -s /bin/bash erigon

######################################################################################
#####################            ERIGON                        #######################
######################################################################################
cd /opt
sudo mkdir erigon
sudo mkdir github && cd github
sudo git clone https://github.com/ledgerwatch/erigon.git
cd erigon
git checkout devel
sudo make
sudo cp -r ./build /opt/erigon/
sudo mkdir -p /data/erigon/datadir
sudo chown -R erigon:erigon /data/erigon

echo  "[program:erigon]
command=bash -c '/opt/erigon/bin/erigon --datadir="/data/erigon/datadir" --private.api.addr="localhost:9595" --http.addr="0.0.0.0" --http.port=8545 --http.vhosts="*" --rpc.gascap=50000000 --rpc.batch.concurrency=100 --http.corsdomain="*" --http.api="eth,erigon,web3,net,debug,trace,txpool" --ws'
user=erigon
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/erigon.err.log
stderr_logfile_maxbytes=1000000
stderr_logfile_backups=10
stdout_logfile=/var/log/supervisor/erigon.out.log
stdout_logfile_maxbytes=1000000
stdout_logfile_backups=10
stopwaitsecs=300" >> /etc/supervisor/conf.d/erigon.conf \

sudo systemctl enable supervisor
sudo systemctl start supervisor
sudo supervisorctl update
sleep  5
supervisorctl status erigon

######################################################################################
#####################                Node Exporter             #######################
######################################################################################

cd $HOME
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin
rm -r node_exporter-1.3.1.linux-amd64*
sudo useradd -rs /bin/false node_exporter

echo "[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/node_exporter.service \

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

sleep 5

######################################################################################
#####################                Prometheus                #######################
######################################################################################
cd $HOME
wget https://github.com/prometheus/prometheus/releases/download/v2.36.1/prometheus-2.36.1.linux-amd64.tar.gz
tar -xf prometheus-2.36.1.linux-amd64.tar.gz
sudo mv prometheus-2.36.1.linux-amd64/prometheus prometheus-2.36.1.linux-amd64/promtool /usr/local/bin
sudo mkdir /etc/prometheus /var/lib/prometheus
sudo mv prometheus-2.36.1.linux-amd64/consoles prometheus-2.36.1.linux-amd64/console_libraries /etc/prometheus
rm -r prometheus-2.36.1.linux-amd64*

echo "global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'erigon'
    metrics_path: /debug/metrics/prometheus
    scrape_interval: 10s
    scheme: http
    static_configs:
       - targets: ['localhost:6060','localhost:6061']" >> /etc/prometheus/prometheus.yml \
       
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus

echo "[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/prometheus.service \

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

sleep 5

######################################################################################
#####################                GRAFANA                   #######################
######################################################################################

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/enterprise/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana-enterprise
sleep 5
wget https://raw.githubusercontent.com/kw1knode/erigon_bash/kw1knode-alpha/metrics.json -P /etc/grafana/provisioning/dashboards
wget https://raw.githubusercontent.com/kw1knode/erigon_bash/kw1knode-alpha/dashboard.yml -P /etc/grafana/provisioning/dashboards
wget https://raw.githubusercontent.com/kw1knode/erigon_bash/kw1knode-alpha/prometheus.yaml
systemctl restart grafana-server


