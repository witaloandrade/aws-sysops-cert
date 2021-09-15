#!/bin/bash
yum update -y
yum install httpd php php-mysql stress -y
cd /etc/httpd/conf
cp httpd.conf httpdconf.backup
rm -rf httpd.conf
wget https://s3-eu-west-1.amazonaws.com/acloudguru-wp/httpd.conf
cd /var/www/html
echo "I'M Healthy" > healthy.html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf latest.tar.gz
chmod -R 755 wp-content
chown -Rf apache:apache wp-content
mkdir /mnt/data
cp /etc/fstab  /etc/fstab.backup
echo 'fs-8fc85ac6.efs.us-east-1.amazonaws.com:/ /mnt/data nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0' >> /etc/fstab
mount -a
rsync -Crapvz /mnt/data/* /var/www/html/
chmod -R 755 wp-content
chown -Rf apache:apache wp-content
service httpd start
chkconfig httpd on
cp /etc/crontab /etc/crontab.backup
echo '*/5  *  *  *  * root rsync -Crapvz  /var/www/html/* /mnt/data/' >> /etc/crontab
