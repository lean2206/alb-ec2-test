#!/bin/bash

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

# Obtén la información de la instancia
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN")
PRIVATE_DNS=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname -H "X-aws-ec2-metadata-token: $TOKEN")
SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac -H "X-aws-ec2-metadata-token: $TOKEN")/subnet-id -H "X-aws-ec2-metadata-token: $TOKEN")

# Actualiza los paquetes disponibles e instala Apache
sudo yum update -y
sudo yum install -y httpd

# Habilita y comienza el servicio de Apache
sudo systemctl enable httpd
sudo systemctl restart httpd

set +H

# Crea una página web de prueba con la información de la instancia
echo "<html><body><h1>EC2 en Amazon Linux! </h1><p>IP Privada: $PRIVATE_IP</p><p>Private DNS: $PRIVATE_DNS</p><p>Subnet ID: $SUBNET_ID</p></body></html>" | sudo tee /var/www/html/index.html
