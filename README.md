Simple script to install and run erigon node + rpcdaemon.

#### **Check on the erigon service:**
`supervisorctl status erigon`

`tail -f /var/log/supervisor/erigon.err.log`

#### **Check on the rpcdaemon status:**
`supervisorctl status rpcdaemon `

`tail -f /var/log/supervisor/rpcdaemon.err.log`

#### **If any changes are made run:**

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








