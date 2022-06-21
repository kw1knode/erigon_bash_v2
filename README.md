Simple script to install and run erigon node + rpcdaemon
========================================================
#### **Download install.sh**
`https://github.com/kw1knode/erigon_bash.git`

`cd erigon_bash`

`chmod +x install.sh`

#### **Run install.sh**
`./install.sh`

#### **Check on the erigon service:**
`supervisorctl status erigon`

`tail -f /var/log/supervisor/erigon.err.log`


#### **Edit .confs run:**
`nano /etc/supervisor/conf.d/erigon.conf`

#### **Update .conf:**

`supervisorctl update`



#### **Updating Node**

```>cd /opt/github/erigon/
git pull
make
supervisorctl stop rpcdaemon
supervisorctl stop erigon
cp -r ./build/bin /opt/erigon/
supervisorctl start erigon
supervisorctl start rpcdaemon
```


#### **Allow Peers**
```ufw allow 30303```

#### **Allow RPC endpoint**
```ufw allow from 1.1.1.1 to any port 8545```

#### **Erigon 8.03 Alpha **
```chaindata``` folder was moved from ```datadir/erigon/chaindata``` into ```datadir/chaindata``` Please move ```chaindata``` manually before starting the new version








