upstream leech-radarr{
	server localhost:6907;
}

server {
	listen 443;
	server_name radarr.yourDomainName.com;
	access_log /home/webapps/logs/radarr.yourDomainName.com.access.log;
        error_log /home/webapps/logs/radarr.yourDomainName.com.error.log;

	auth_basic "Restricted";
	auth_basic_user_file /etc/nginx/passwd/wesh;

        add_header Cache-Control no-cache;
        expires 0;

	location / {
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $http_host;
		proxy_redirect off;
		proxy_pass http://leech-radarr/;
	}
}
