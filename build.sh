ETCD_REPO="etcd-io/etcd"
GOREMAN_REPO="mattn/goreman"

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

ETCD_LATEST_VERSION=`get_latest_release $ETCD_REPO`
GOREMAN_LATEST_VERSION=`get_latest_release $GOREMAN_REPO`

echo $ETCD_LATEST_VERSION
echo $GOREMAN_LATEST_VERSION

ETCD_DIR="etcd"
GOREMAN_DIR="goreman"

if [ "$1" -ne "--build" ]; then
    rm -rf $ETCD_DIR
    rm -rf $GOREMAN_DIR

    if [ ! -f $ETCD_DIR"/etcd" ];then
        mkdir $ETCD_DIR
        wget "https://github.com/coreos/etcd/releases/download/"$ETCD_LATEST_VERSION"/etcd-"$ETCD_LATEST_VERSION"-linux-amd64.tar.gz" -O $ETCD_DIR/etcd.tar.gz
        tar xvf $ETCD_DIR/etcd.tar.gz -C etcd --strip-components=1
    fi

    if [ ! -f $GOREMAN_DIR"/goreman" ]; then
        mkdir $GOREMAN_DIR
        wget "https://github.com/mattn/goreman/releases/download/"$GOREMAN_LATEST_VERSION"/goreman_linux_amd64.zip" -O $GOREMAN_DIR/goreman.zip
        unzip $GOREMAN_DIR/goreman.zip -d goreman
    fi
fi

docker build -t "etcd-goreman-golang":"$ETCD_LATEST_VERSION"