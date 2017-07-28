#! /bin/bash

dominio="homemdasneves"
caminho="/var/www/homemdasneves"

read -p"Qual o dominio desejado?(Sem wwww.com)" -i"?" dominio


cp /etc/apache2/sites-available/000-default.conf  /etc/apache2/sites-available/www.$dominio.com.conf
echo '<VirtualHost *:80>' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo 'ServerName www.'$dominio'.com' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo '' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo 'ServerAdmin webmaster@localhost' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo 'DocumentRoot '$caminho >> /etc/apache2/sites-available/www.$dominio.com.conf
echo '' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo '' >> /etc/apache2/sites-available/www.$dominio.com.conf
echo '</VirtualHost>' >> /etc/apache2/sites-available/www.$dominio.com.conf

mkdir $caminho

a2ensite

service apache2 start
service apache2 reload

echo "Se ao acessar você ver isso! Significa que deu certo!" > $caminho/index.html

