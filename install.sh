#!/bin/bash

#Prerequisites
apt-get install -y build-essential supervisor wget git

echo "#Prerequisites Installed"

#Install Golang
wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/local/bin/go

echo "Golang Installed"

#Create Isolated User
useradd -m -s /bin/bash erigon

cd /opt
mkdir erigon
mkdir github && cd github
git clone https://github.com/ledgerwatch/erigon.git
cd erigon

PS3='Choose Erigon Branch: '
branch=("Stable" "Latest" "Quit")
select fav in "${branch[@]}"; do
    case $fav in
        "Stable")
            echo "you have chosen stable branch"
	     git checkout stable
	     break
            ;;
        "Latest")
            echo "you have chosen latest branch"
	    git checkout devel
        
        break
            ;;
        
	"Quit")
	    echo "User requested exit"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done

make
cp -r ./build/bin /opt/erigon/

mkdir -p /data/erigon/datadir
chown -R erigon:erigon /data/erigon

echo  "[program:erigon]
command=bash -c '/opt/erigon/bin/erigon --datadir="/data/erigon/datadir" --private.api.addr="0.0.0.0:9090"'
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

echo "[program:rpcdaemon]
command=bash -c '/opt/erigon/build/bin/rpcdaemon --datadir="/data/erigon/datadir" --private.api.addr="localhost:9090" --http.addr="0.0.0.0" --http.port=8545 --http.vhosts="*" --http.corsdomain="*" --http.api="eth,erigon,web3,net,debug,trace,txpool,shh" --ws'
user=erigon
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/rpcdaemon.err.log
stderr_logfile_maxbytes=1000000
stderr_logfile_backups=10
stdout_logfile=/var/log/supervisor/rpcdaemon.out.log
stdout_logfile_maxbytes=1000000
stdout_logfile_backups=10" >> /etc/supervisor/conf.d/rpcdaemon.conf \

systemctl enable supervisor
systemctl start supervisor
supervisorctl update
supervisorctl status rpcdaemon
sleep 2
supervisorctl status erigon




