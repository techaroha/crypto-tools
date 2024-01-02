# Steps to use build-crypto bash file

Linux Bash Script file contains all the steps required to build litecoin 0.14 (https://github.com/techaroha/litecoin) source code on Ubuntu 20.04 LTS and above versions.

Download the bash script file. Provide sufficient permission to execute the bash file using command
```
sudo chmod u+x build-crypto.sh
```
The bash file will execute below steps sequentially
1. Download all the dependency packages required to build litecoin on Ubuntu 20.04 LTS and above versions
2. Download and install BERKELEY-DB and patch code to run it on Ubuntu 20.04 LTS and above versions.
3. Build coin dependencies and coin node.
4. Create Coin configuration file.
5. Create coin command alias so that you can execute daemon and cli commands from anywhere. E.g. newtumcoind, newtumcoin-cli getinfo

You can execute bash file using below command 
```
./build-crypto.sh -s coin_source_directory -c coinname
```
### Parameters:
**coin_source_directory** - Directory relative path where your coin source code is stored  
**coinname** - Your coin name in small letters e.g. newtumcoin

