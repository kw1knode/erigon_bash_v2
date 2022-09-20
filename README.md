Simple script to install and run erigon node
========================================================
### **Download install.sh** ###
`git clone https://github.com/kw1knode/erigon_bash.git`

`cd erigon_bash`

`chmod +x install.sh`

### **Run install.sh** ###
`./install.sh`

### **Check on the erigon service:** ###
`sudo journalctl -fu erigon`


### **To make changes to erigon.service** ###

`sudo nano /etc/systemd/system/erigon.service`


### **After making changes, dont forget to update** ###

`sudo systemctl daemon-reload`
`sudo systemctl restart erigon`


### **Allow Peers** ###
```ufw allow 30303```

### **Allow RPC endpoint** ###
```ufw allow from 1.1.1.1 to any port 8545```








