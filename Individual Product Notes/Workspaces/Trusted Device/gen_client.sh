#!/bin/bash
echo "Generating cert for $1.local"

openssl genrsa -aes256 -out $1.local.key 2048

openssl req -new -key $1.local.key -out $1.local.csr -subj "/C=MyCountry/ST=MyCounty/L=MyTown/O=MyOrganisation/OU=MyOrganisationUnit/CN=$1.local.client"

openssl x509 -req -in $1.local.csr -CA CA.pem -CAkey CA.key -CAcreateserial -out $1.local.crt -days 365 -sha256   -extensions v3_req -extfile ext.txt

openssl pkcs12 -export -aes256 -out  $1.local.full.pfx -inkey $1.local.key -in  $1.local.crt -certfile CA.pem
