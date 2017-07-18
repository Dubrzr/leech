# Variables

LINUX_USER = leech;
MAIN_DIR = /home/webapps/apps/leech;
OUTPUT_DIR = $MAIN_DIR/output;
DOWNLOADS_DIR = $OUTPUT_DIR/downloads;
TZ = Europe/Paris;
LISTEN = 127.0.0.1;
D_SUBNET = 172.50.0;
D_DNS = 8.8.8.8;
D_NETWORK_NAME = leech;

# CHECK RIGHTS
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 1>&2;
   exit 1;
fi

# CREATE USER IF NEEDED
if ! grep $LINUX_USER /etc/passwd; then
  echo "User $LINUX_USER does not exists, please create it!" 1>&2;
  exit 2;
fi
UID = id -u $LINUX_USER;
GID = id -g $LINUX_USER;


# CREATE LOCAL FOLDERS
mkdir -p $OUTPUT_DIR/tv;
mkdir -p $OUTPUT_DIR/movies;
mkdir -p $DOWNLOADS_DIR/completed;

# CREATE DOCKER SUBNET
sudo docker network create --subnet $D_SUBNET.0/16 $D_NETWORK_NAME;

# DELUGE
mkdir -p $MAIN_DIR/deluge/appdata;
sudo docker create --name deluge -v $MAIN_DIR/deluge/appdata:/config -v $DOWNLOADS_DIR:/downloads -e PGID=$GID -e PUID=$UID -e TZ=$TZ -p $LISTEN:6906:8112 --ip $D_SUBNET.56 --network $D_NETWORK_NAME --dns $D_DNS linuxserver/deluge

# NZBGET
mkdir -p $MAIN_DIR/nzbget/appdata;
sudo docker create --name nzbget -v $MAIN_DIR/nzbget/appdata:/config -v $DOWNLOADS_DIR:/downloads -e PGID=$GID -e PUID=$UID -e TZ=$TZ -p $LISTEN:6901:6789 --ip $D_SUBNET.51 --network $D_NETWORK_NAME --dns $D_DNS linuxserver/nzbget

# HYDRA
mkdir -p $MAIN_DIR/nzbhydra/appdata;
sudo docker create --name hydra -v $MAIN_DIR/nzbhydra/appdata/:/config -v $DOWNLOADS_DIR/completed:/downloads -e PGID=$GID -e PUID=$UID -e TZ=$TZ -p $LISTEN:6905:5075 --ip $D_SUBNET.55 --network $D_NETWORK_NAME --dns $D_DNS linuxserver/hydra

# SONARR
mkdir $MAIN_DIR/sonarr/appdata;
sudo docker create --name sonarr -v $MAIN_DIR/sonarr/appdata:/config -v $DOWNLOADS_DIR/completed:/downloads -v $OUTPUT_DIR/tv:/tv -e PGID=$GID -e PUID=$UID -e TZ=$TZ -v /etc/localtime:/etc/localtime:ro -p $LISTEN:6902:6902 --ip $D_SUBNET.52 --network $D_NETWORK_NAME --dns $D_DNS linuxserver/sonarr

# RADARR
mkdir $MAIN_DIR/radarr/appdata;
sudo docker create --name radarr -v $MAIN_DIR/radarr/appdata:/config -v $DOWNLOADS_DIR/completed:/downloads -v $OUTPUT_DIR/movies:/movies -e PGID=$GID -e PUID=$UID TZ=$TZ -v /etc/localtime:/etc/localtime:ro -p $LISTEN:6907:7878 --ip $D_SUBNET.57 --network $D_NETWORK_NAME --dns $D_DNS linuxserver/radarr;

sudo chown -R $MAIN_DIR;
sudo chmod -R 750 $MAIN_DIR; 

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
