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

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Stable Branch")
            echo "you chose stable branch"
            git checkout stable
            ;;
        "Latest Branch")
            echo "you chose latest release"
            git checkout devel
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

make
cp -r ./build/bin /opt/erigon/
