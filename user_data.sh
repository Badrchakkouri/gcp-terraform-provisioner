#!/bin/sh
sudo yum -y install epel-release
sudo yum -y install nginx
cd /usr/share/nginx/html/
sudo mv index.html index.html.old
echo "
<h1 style=\"text-align: center;\"><strong>Badr says hello from GCP!&nbsp;</strong><span></span></h1>
<p><span><img src=\"https://media.giphy.com/media/ASd0Ukj0y3qMM/giphy.gif\" alt=\"\" width=\"480\" height=\"360\" style=\"display: block; margin-left: auto; margin-right: auto;\" /></span></p>
" | sudo tee -a index.html
sudo chmod 644 index.html
sudo systemctl restart nginx
