Erigon Archive + Lighthouse Beacon Install
========================================================
### **Install Rust** ###

If you dont currently have rust installed, log out and back in after install.

`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`



### **Download install.sh** ###
`git clone https://github.com/kw1knode/erigon_bash_v2.git`

`cd erigon_bash_v2`

`chmod +x install.sh`

### **Edit checkpoint url to a trusted source or remove to sync from genesis** ###

`--checkpoint-sync-url https://<PROJECT-ID>:<PROJECT-SECRET>@eth2-beacon-mainnet.infura.io`

Is checkpoint sync less secure? No, in fact it is more secure! Checkpoint sync guards against long-range attacks that genesis sync does not. This is due to a property of Proof of Stake consensus known as Weak Subjectivity.


### **Run install.sh** ###
`./install.sh`

### **Check on the erigon service:** ###

`sudo journalctl -fu erigon`

### ***Check on lighthouse beacon service** ###

`sudo journalctl -fu lighthousebeacon`

### **To make changes to erigon.service** ###

`sudo nano /etc/systemd/system/erigon.service`

### **To make changes to lighthousebeacon.service** ###

`sudo nano /etc/systemd/system/lighthousebeacon.service`

### **After making changes, dont forget to update** ###

`sudo systemctl daemon-reload`

`sudo systemctl restart erigon`

`sudo systemctl restart lighthousebeacon`


### **Allow Peers** ###

```ufw allow 30303```

```ufw allow 9000```

### **Allow RPC endpoint** ###
```ufw allow from 1.1.1.1 to any port 8545```








