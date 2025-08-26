## Step by step

cp nginx.conf.example nginx.conf
cp default.conf.example default.conf

chmod +x create-certs.sh

./create-certs

chmod +x renew_ssl.sh

add to crontab:
sudo nano /etc/crontab

0 2 * * * /home/chatbot/chatbot/n8n/nginx/renew_ssl.sh >> /var/log/renew_ssl.log 2>&1

docker compose up -d