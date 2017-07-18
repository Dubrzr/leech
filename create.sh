#!/bin/bash


# VARIABLES
linux_user="leech";
main_dir="/home/webapps/apps/leech";
output_dir="$main_dir/output";
downloads_dir="$output_dir/downloads";
tz="europe/paris";
listen="127.0.0.1";
d_subnet="172.50.0";
d_dns="8.8.8.8";
d_network_name="leech";


# CHECK RIGHTS
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 1>&2;
   exit 1;
fi


# GET USER UID AND GID
if ! grep $linux_user /etc/passwd &>/dev/null; then
  echo "User $linux_user does not exists, please create it!" 1>&2;
  exit 2;
fi
uid=$(id -u $linux_user);
gid=$(id -g $linux_user);


# CREATE LOCAL FOLDERS
mkdir -p $output_dir/tv;
mkdir -p $output_dir/movies;
mkdir -p $downloads_dir/completed;


# CREATE DOCKER SUBNET
sudo docker network create --subnet $d_subnet.0/16 $d_network_name; 

# DELUGE
mkdir -p $main_dir/deluge/appdata;
sudo docker create --name deluge -v $main_dir/deluge/appdata:/config -v $downloads_dir:/downloads -e pgid=$gid -e puid=$uid -e tz=$tz -p $listen:6906:8112 --ip $d_subnet.56 --network $d_network_name --dns $d_dns linuxserver/deluge

# NZBGET
mkdir -p $main_dir/nzbget/appdata;
sudo docker create --name nzbget -v $main_dir/nzbget/appdata:/config -v $downloads_dir:/downloads -e pgid=$gid -e puid=$uid -e tz=$tz -p $listen:6901:6789 --ip $d_subnet.51 --network $d_network_name --dns $d_dns linuxserver/nzbget

# HYDRA
mkdir -p $main_dir/nzbhydra/appdata;
sudo docker create --name hydra -v $main_dir/nzbhydra/appdata/:/config -v $downloads_dir/completed:/downloads -e pgid=$gid -e puid=$uid -e tz=$tz -p $listen:6905:5075 --ip $d_subnet.55 --network $d_network_name --dns $d_dns linuxserver/hydra

# SONARR
mkdir -p $main_dir/sonarr/appdata;
sudo docker create --name sonarr -v $main_dir/sonarr/appdata:/config -v $downloads_dir/completed:/downloads -v $output_dir/tv:/tv -e pgid=$gid -e puid=$uid -e tz=$tz -v /etc/localtime:/etc/localtime:ro -p $listen:6902:6902 --ip $d_subnet.52 --network $d_network_name --dns $d_dns linuxserver/sonarr

# RADARR
mkdir -p $main_dir/radarr/appdata;
sudo docker create --name radarr -v $main_dir/radarr/appdata:/config -v $downloads_dir/completed:/downloads -v $output_dir/movies:/movies -e pgid=$gid -e puid=$uid -e tz=$tz -v /etc/localtime:/etc/localtime:ro -p $listen:6907:7878 --ip $d_subnet.57 --network $d_network_name --dns $d_dns linuxserver/radarr;

sudo chown -R $linux_user $main_dir;
sudo chmod -R 750 $main_dir; 

sudo systemctl enable leech@deluge;
sudo systemctl start leech@deluge;
sudo systemctl enable leech@nzbget;
sudo systemctl start leech@nzbget;
sudo systemctl enable leech@hydra;
sudo systemctl start leech@hydra;
sudo systemctl enable leech@sonarr;
sudo systemctl start leech@sonarr;
sudo systemctl enable leech@radarr;
sudo systemctl start leech@radarr;
