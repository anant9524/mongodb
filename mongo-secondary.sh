#!/bin/bash
echo "$(tput setaf 1)Installing mongoDB repo"
tput setaf 7
sudo wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
sudo echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
echo "$(tput setaf 1)Installing binaries"
tput setaf 7
sudo apt-get update
echo "$(tput setaf 1)Installing mongodb service"
tput setaf 7
sudo apt-get install -y mongodb-org
sleep 5
echo "$(tput setaf 1)Enabling mongodb service to auto start on reboot"
tput setaf 7
sudo systemctl enable mongod
sudo systemctl start mongod
sleep 5
echo "$(tput setaf 2)creating mongo key"
tput setaf 7
touch /opt/mongo-keyfile
chmod 400 /opt/mongo-keyfile
chown mongodb:mongodb /opt/mongo-keyfile
echo "$(tput setaf 2)editing conf file"
tput setaf 7
file=/etc/mongod.conf
bindIp=$1
replSetName=$2
sed -i 's/#security/security/g' $file
sed -i 's/security:/security: \n  keyFile: \/opt\/mongo-keyfile /g' $file
sed -i 's/#replication/replication/g' $file
sed -i 's/replication:/replication: \n  replSetName: /g' $file
sed -i 's/bindIp:/bindIp: /g' $file
sed -i 's/bindIp: .*/bindIp: '$bindIp'/' $file
sed -i 's/replSetName:/replSetName: /g' $file
sed -i 's/replSetName:.*/replSetName:'$replSetName'/' $file
echo "$(tput setaf 2)restarting mongo service"
tput setaf 7
systemctl restart mongod
sleep 5
