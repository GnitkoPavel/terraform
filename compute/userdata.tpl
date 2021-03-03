#!/bin/bash
yum install httpd php php-mysql -y
cd /var/www/html
echo "healthy" > healthy.html
echo "${security_group}" > test.html
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf latest.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
wget https://github.com/GnitkoPavel/demo/blob/master/htaccess.txt
mv htaccess.txt .htaccess
service httpd start
chkconfig httpd on