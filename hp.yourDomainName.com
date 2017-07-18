upstream leech-headphones {
	server localhost:6903;
}

server {
	listen 443;
	server_name hp.yourDomainName.com;
	access_log /home/webapps/logs/hp.yourDomainName.com.access.log;
        error_log /home/webapps/logs/hp.yourDomainName.com.error.log;

	auth_basic "Restricted";
	auth_basic_user_file /etc/nginx/passwd/wesh;

	location / {
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_redirect off;
		proxy_pass http://leech-headphones;
                add_header Cache-Control no-cache;
                expires 0;
	}
}
