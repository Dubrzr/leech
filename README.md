# LEECH

This is a bunch of scripts and configurations to setup the follwing apps to work in a docker subnet:
* [Sonarr](https://github.com/Sonarr/Sonarr) - TV shows
* [Radarr](https://github.com/Radarr/Radarr) - Movies
* [Deluge](https://github.com/deluge-torrent/deluge) - Torrents
* [NZBGet](https://github.com/nzbget/nzbget) - Newsgroups
* [NZBHydra](https://github.com/theotherp/nzbhydra) - Newsgroups search 

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
