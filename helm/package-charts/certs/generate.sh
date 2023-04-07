domain=sysdaemons.com
org=sysdaemons
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=${org} Inc./CN=${domain}' -keyout ${domain}.key -out ${domain}.crt
openssl req -out wildcard.${domain}.csr -newkey rsa:2048 -nodes -keyout wildcard.${domain}.key -subj "/CN=*.${domain}/O=${org} organization"
openssl x509 -req -sha256 -days 365 -CA ${domain}.crt -CAkey ${domain}.key -set_serial 0 -in wildcard.${domain}.csr -out wildcard.${domain}.crt

kubectl create -n istio-system secret tls ${org}-wildcard-tls --key=wildcard.${domain}.key --cert=wildcard.${domain}.crt


