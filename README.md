# WTF?

shell script to update qtv.cfg files

### Requirements

* bash
* wget
* sed
* git

;-)

### Example outputs:
```
# ./qtv.sh
QTV cfg updater by d2@tdhack.com

[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/servers/servers.txt
[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/north_america/servers.txt
[i] verifying your qtv.cfg file
        [+] backup of existing file
        [+] preparing input data
        [+] compiling new qtv.cfg
        [+] cleaning tmp files
[*] done, restart qtv manually
```
### installation
* cd $HOME
* git clone https://github.com/d2-d2/qtvcfg
* chmod 755 $HOME/qtvcfg/qtv.sh
* insert crontab entry: 0 0 * * * $HOME/qtv.sh > /dev/null 2>&1

### todo
* restart qtv service automatically

### Ideas? Reports?

Send them to: d2@tdhack.com
