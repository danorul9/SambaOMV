#!/bin/bash

#updating the apt packages index
sudo apt update 

#Install the Samba package
sudo apt install samba

#check whether the Samba server is running
#sudo systemctl status smbd

#allow incoming UDP connections on ports 137 and 138 and TCP connections on ports 139 and 445
sudo ufw allow 'Samba'


#backup the original samba configuration file 
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.orig

#creating a shared samba directory where the files will be stored
sudo mkdir -p /mnt/Public

#set the appropriate permissions on the directory.
sudo chmod -R 0775 /mnt/Public #Change as required
sudo chown -R nobody:nogroup /mnt/Public

#Update config from git
sudo cp ./etc/samba/smb.conf /etc/samba/smb.conf

#restart the Samba services
sudo systemctl restart smbd
sudo systemctl restart nmbd

