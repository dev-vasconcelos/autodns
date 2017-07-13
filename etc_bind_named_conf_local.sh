#! /bin/bash

ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
IFS='.' read -ra IPS <<< "$ip"

dominio=repodocker

echo '//limpo' > /etc/bind/named.conf.local
echo '//include "/etc/bind/zones.rfc1918";' >> /etc/bind/named.conf.local

echo 'zone "'$dominio'"{' >> /etc/bind/named.conf.local
echo 'type master;' >>/etc/bind/named.conf.local
echo 'file /etc/bind/zones/'$dominio'.db' >> /etc/bind/named.conf.local
echo '};' >> /etc/bind/named.conf.local

echo 'zone "'${IPS[2]}'.'${IPS[1]}'.'${IPS[0]}'.in-addr.arpa"{' >> /etc/bind/named.conf.local
echo 'type master;' >> /etc/bind/named.conf.local
echo '};' >> /etc/bind/named.conf.local     
