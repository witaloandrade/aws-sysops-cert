#!/bin/bash
yum install httpd -y
yum update -y
service httpd start
chkconfig httpd on
aws s3 cp --recursive s3://www.anybucketname.com/ /var/www/html/