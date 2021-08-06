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
        "stable")
            echo "you have chosen stable branch"
	     git checkout stable
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
