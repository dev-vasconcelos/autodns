#! /bin/bash

ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
IFS='.' read -ra IPS <<< "$ip" 


DATE=`date +%Y%m%d%H`
dominio="repositoriolegal"
usu=$(hostname)

read -p"qual o dominio entrado no apache? (apenas o nome sem www.com)" -i"?" dominio

echo '// prime the server with knowledge of the root servers' > /etc/bind/named.conf.default-zones 
echo 'zone "."{' >> /etc/bind/named.conf.default-zones 
echo '  type hint;' >> /etc/bind/named.conf.default-zones 
echo '  file "/etc/bind/db.root";' >> /etc/bind/named.conf.default-zones 
echo '};' >> /etc/bind/named.conf.default-zones 
echo '' >> /etc/bind/named.conf.default-zones 
echo 'zone "localhost"{' >> /etc/bind/named.conf.default-zones 
echo '  type master;' >> /etc/bind/named.conf.default-zones 
echo '  file "/etc/bind/db.local";' >> /etc/bind/named.conf.default-zones 
echo '};' >> /etc/bind/named.conf.default-zones 
echo '' >> /etc/bind/named.conf.default-zones 
echo 'zone "127.in-addr.arpa"{' >> /etc/bind/named.conf.default-zones 
echo '  type master;' >> /etc/bind/named.conf.default-zones 
echo 'file "/etc/bind/db.127";' >> /etc/bind/named.conf.default-zones 
echo '};' >> /etc/bind/named.conf.default-zones 
echo "" >> /etc/bind/named.conf.default-zones 
echo 'zone "0.in-addr.arpa"{' >> /etc/bind/named.conf.default-zones 
echo '  type master;' >> /etc/bind/named.conf.default-zones 
echo '  file "/etc/bind/db.0";' >> /etc/bind/named.conf.default-zones 
echo "};" >> /etc/bind/named.conf.default-zones 
echo ''>> /etc/bind/named.conf.default-zones  
echo 'zone "255.in-addr.arpa"{' >> /etc/bind/named.conf.default-zones 
echo '  type master;' >> /etc/bind/named.conf.default-zones 
echo '  file "/etc/bind/db.255";' >> /etc/bind/named.conf.default-zones 
echo '};' >> /etc/bind/named.conf.default-zones 
echo '' >> /etc/bind/named.conf.default-zones 
echo 'zone "'$dominio'.com"{' >> /etc/bind/named.conf.default-zones 
echo '  type master;' >> /etc/bind/named.conf.default-zones 
echo '  file "/etc/bind/'$dominio'.db";'>> /etc/bind/named.conf.default-zones 
echo '};' >> /etc/bind/named.conf.default-zones 

cp /etc/bind/db.0 /etc/bind/$dominio.db

echo ';' > /etc/bind/$dominio.db
echo '; BIND rever data file for broadcast zone' >> /etc/bind/$dominio.db
echo ';' >> /etc/bind/$dominio.db
echo '$TTL  604800' >> /etc/bind/$dominio.db
echo '@ IN SOA '$usu'.'$dominio'.com. root.'$dominio'.com. ('
echo '     '$DATE' ;Serial' >> /etc/bind/$dominio.db
echo '     604800 ; Serial' >> /etc/bind/$dominio.db
echo '     86400 ; Retry' >> /etc/bind/$dominio.db
echo '     241920 ; Expire' >> /etc/bind/$dominio.db
echo '     604800 ) ; Default TTL' >> /etc/bind/$dominio.db
echo ';' >> /etc/bind/$dominio.db
echo '@ IN NS '$usu'.'$dominio'.com.' >> /etc/bind/$dominio.db
echo $usu' IN A '${IPS[0]}'.'${IPS[1]}'.'${IPS[2]}'.'${IPS[3]} >> /etc/bind/$dominio.db
echo 'www IN CNAME '$usu'.'$dominio'.com.' >> /etc/bind/$dominio.db

service bind9 restart

