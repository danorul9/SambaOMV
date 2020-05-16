#!/bin/bash
#Change as required
PublicFolder="/mnt/Public"
PrivateFolder="/mnt/Private"
PrivateUser="user"
Password="pass"

#updating the apt packages index
#sudo apt update 

#Install the Samba package
#sudo apt install samba

#check whether the Samba server is running
#sudo systemctl status smbd

#allow incoming UDP connections on ports 137 and 138 and TCP connections on ports 139 and 445
sudo ufw allow 'Samba'


#backup the original samba configuration file 
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.orig

#creating a shared samba directory where the files will be stored
sudo mkdir -p $PublicFolder

#set the appropriate permissions on the directory.
sudo chmod -R 0777 $PublicFolder 
sudo chown -R nobody:nogroup $PublicFolder

#Configure Samba Private Share
#create a samba group called smbgroup for the share.. only members will have access
sudo addgroup smbgroup

#Add a user without home directory and ssh
#sudo useradd -M $PrivateUser --shell=/bin/false
sudo userdel $PrivateUser
sudo useradd $PrivateUser 
#sudo useradd -M $PrivateUser #--shell=/bin/false

#Add a user to the smbgroup
sudo usermod -a -G smbgroup $PrivateUser

#All users who need to access a protected samba share will need to type a password
#sudo smbpasswd -a $PrivateUser
echo -ne "$Password\n$Password\n" | sudo smbpasswd -a $PrivateUser

#Create a protected share in the /samba directory.

sudo mkdir -p $PrivateFolder

#Then give only root and members group access to this share.

sudo chown -R root:smbgroup $PrivateFolder
sudo chmod -R 0770 $PrivateFolder

#Update config from git
sudo cp ./etc/samba/smb.conf /etc/samba/smb.conf

#restart the Samba services
sudo systemctl restart smbd
sudo systemctl restart nmbd
#sudo service smbd restart

