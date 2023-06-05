#!/bin/bash

yum update -y
yum install git -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html/
git clone https://github.com/bennieyh/Project3-TEST.git .
#mv -v /var/www/html/index.html /var/www/html/index.html.backup
mv -v /var/www/html/webpage/index.html /var/www/html/index.html
rm -rf /var/www/html/.git
#rm -rf /var/www/html/Shrek/
systemctl restart httpd
