Simple script to install and run erigon node
========================================================
### **Download install.sh** ###
`git clone https://github.com/kw1knode/erigon_bash.git`

`cd erigon_bash`

`chmod +x install.sh`

### **Run install.sh** ###
`./install.sh`

### **Check on the erigon service:** ###
`supervisorctl status erigon`

`tail -f /var/log/supervisor/erigon.err.log`

### **If any changes are made to .confs run:** ###

`/etc/supervisor/conf.d/erigon.conf`

`supervisorctl update`

### **Updating Node** ###

```>cd /opt/github/erigon/
git pull
make
supervisorctl stop erigon
cp -r ./build/bin /opt/erigon/
supervisorctl start erigon
```


### **Allow Peers** ###
```ufw allow 30303```

### **Allow RPC endpoint** ###
```ufw allow from 1.1.1.1 to any port 8545```








