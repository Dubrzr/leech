upstream leech-deluge {
	server localhost:6906;
}

server {
	listen 443;
	server_name deluge.yourDomainName.com;
	access_log /home/webapps/logs/deluge.yourDomainName.com.access.log;
        error_log /home/webapps/logs/deluge.yourDomainName.com.error.log;

	client_max_body_size 100m;

	auth_basic "Restricted";
	auth_basic_user_file /etc/nginx/passwd/wesh;

	location / {
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto https;
		proxy_pass http://leech-deluge;
	}
}
