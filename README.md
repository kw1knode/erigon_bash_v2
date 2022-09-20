Simple script to install and run erigon node
========================================================
### **Download install.sh** ###
`git clone https://github.com/kw1knode/erigon_bash_v2.git`

`cd erigon_bash_v2`

`chmod +x install.sh`

### **Run install.sh** ###
`./install.sh`

### **Check on the erigon service:** ###

`sudo journalctl -fu erigon`

### ***Check on lighthouse beacon service** ###

sudo journalctl -fu lighthousebeacon

### **To make changes to erigon.service** ###

`sudo nano /etc/systemd/system/erigon.service`

### **To make changes to lighthousebeacon.service** ###

`sudo nano /etc/systemd/system/lighthousebeacon.service`

### **After making changes, dont forget to update** ###

`sudo systemctl daemon-reload`

`sudo systemctl restart erigon`

`sudo systemctl lighthousebeacon`


### **Allow Peers** ###

```ufw allow 30303```

```ufw allow 9000```

### **Allow RPC endpoint** ###
```ufw allow from 1.1.1.1 to any port 8545```








