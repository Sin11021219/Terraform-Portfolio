#!/bin/bash
#======yum update -y======
yum update -y

## Apache　Setup
#======yum install -y httpd======
yum install -y httpd
#======chown -R apache:apache /var/www/html======
chown -R apache:apache /var/www/html
#======systemctl start httpd======
systemctl start httpd
#======systemctl enable httpd======
systemctl enable httpd
#======create index.html======
echo "<html><body><h1>Hello, World!</h1></body></html>" >> /var/www/html/index.html
 
 