# WTF?

shell script to update qtv.cfg files

### Requirements

* bash
* wget
* sed
* git
* nohup
* netcat

### Initial configuration

Before you run this script, please open it and configure following variables:
- BACKUPDIR
- QTVFILE
- QTVBIN
- UPDATEURL
- QTVAUTORESTART

All of them are well documented so you should have no problems with filling them up.

### Example outputs:
```
# ./qtv.sh
[2014-11-09@21:19:15] starting new event
QTV cfg updater by d2@tdhack.com, version: 0.7

[i] checking for required packages
        [+] all good
[i] verifying your /home/users/d2/qtv/qtv.cfg file
[i] checking if /home/users/d2/qtv/qtv.bin exists
[i] checking if /home/users/d2/qtvbackup exists
[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/servers/servers.txt
        [+] done, 299 servers downloaded
[i] fixing duplicates, password-protected and not working servers
        [+] done, final list have now 241 records
[+] checking QW servers (241 in initial list), check bin/qtv.sh.err for details
        [8/241] 109.229.162.150:30000 not a QW server
        [40/241] 181.41.214.162:28502 not a QW server
        [48/241] 192.227.140.108:27501 not a QW server
        [i] done, 238 servers in the final list
[i] backup of existing file
[i] preparing input data
[i] compiling new /home/users/d2/qtv/qtv.cfg
[i] cleaning tmp files
[+] restarting qtv
        [+] running qtv found, PID: 28486, killing it now!
[i] checking crontab entry
        [+] OK, crontab is present
[2014-11-09@21:31:39] end
```
### installation
make sure to replace $HOME with something meaningful, like: /home/d2/

* cd $HOME
* git clone https://github.com/d2-d2/qtvcfg
* chmod 755 $HOME/qtvcfg/qtv.sh

### todo
* move variables from main script into separate cfg file?

### Ideas? Reports?

Send them to: d2@tdhack.com
