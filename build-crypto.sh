#!/bin/bash
set -e

# ENVIRONMENT SETUP
while getopts s:c: flag
do
    case "${flag}" in
        s) dir_coinsource=${OPTARG};;
        c) cryptoname=${OPTARG};;
    esac
done

# ARGUMENTS VALIDATION
if [ -z ${dir_coinsource} ] || [ -z ${cryptoname} ]
  then
    echo "Err: Invalid or No arguments passed. Please pass arguments -s sourcecode_directory -c your_coinname"
    exit
fi

current_user=$(whoami)

# SYSTEM BASIC UPDATES
sudo apt update
sudo apt upgrade -y

# DIRECTORY PERMISSION SETUP
sudo chown -R ${current_user}:${current_user} ${dir_coinsource}
sudo chmod -R 755 ${dir_coinsource}

# INSTALL PREREQUISITES
sudo apt install -y build-essential
sudo apt install -y autoconf libtool pkg-config libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libevent-dev libcanberra-gtk-module libdb++-dev

# ENTER INTO SOURCE DIRECTORY
cd ${dir_coinsource}

# BERKELEY-DB INSTALLATION
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xvf db-4.8.30.NC.tar.gz

sudo chmod -R 755 db-4.8.30.NC

sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h

cd db-4.8.30.NC/build_unix

mkdir -p build

BDB_PREFIX=$(pwd)/build

../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX

sudo make install

cd ../..


# BUILD THE COIN
./autogen.sh
./configure CPPFLAGS="-I${BDB_PREFIX}/include/ -O2" LDFLAGS="-L${BDB_PREFIX}/lib/"

make


# COIN CONFIGURATION SETUP
cd src 
./${cryptoname}d -daemon

sleep 5
./${cryptoname}-cli stop

cat <<EOF > ~/.${cryptoname}/${cryptoname}.conf
rpcuser=coinuser
rpcpassword=coinpassword
rpcallowip=127.0.0.1
daemon=1

EOF

touch ~/.bash_aliases
cat << EOF >> ~/.bash_aliases

alias ${cryptoname}d='`pwd`/${cryptoname}d'
alias ${cryptoname}-cli='`pwd`/${cryptoname}-cli'

EOF

source ~/.bash_aliases
cd ..
