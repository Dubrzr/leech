# LEECH

This is a bunch of scripts and configurations to setup the follwing apps to work in a docker subnet:
* [Sonarr](https://github.com/Sonarr/Sonarr) - TV shows - (Local: 127.0.0.1:6902 | Subnet: 172.50.0.52:6902)
* [Radarr](https://github.com/Radarr/Radarr) - Movies - (Local: 127.0.0.1:6907 | Subnet: 172.50.0.57:7878)
* [Deluge](https://github.com/deluge-torrent/deluge) - Torrents - (Local: 127.0.0.1:6906 | Subnet: 172.50.0.56:8112)
* [NZBGet](https://github.com/nzbget/nzbget) - Newsgroups - (Local: 127.0.0.1:6901 | Subnet: 172.50.0.51:6789)
* [NZBHydra](https://github.com/theotherp/nzbhydra) - Newsgroups search - (Local: 127.0.0.1:6905 | Subnet: 172.50.0.55:5075)

## Requirements

Be sure to have Docker installed

## Installation

1. Create a new user to be used for this
2. Copy leech\@.service to your systemd folder 
3. Edit `create.sh` and change variables to match your needs
4. Run `sudo ./create.sh` to execute the script and install everything!


This script have been tested under Archlinux only.
The script uses docker images provided by [linuxserver.io](http://tools.linuxserver.io/dockers).

## NGINX

You will also find *.com files which are actually nginx configuration examples if you want to expose those apps

## How to configure applications?

When the installation is completed, you will have to configure each app. You can do so by browing their WebUI (at 127.0.0.1:appPort).
Each application has a dedicated ip in the docker subnet, so for example Sonarr will need access to Deluge at 172.50.0.56:8112)
