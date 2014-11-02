# WTF?

shell script to update qtv.cfg files

### Requirements

* bash
* wget
* sed
* git
* nohup

### Example outputs:
```
# ./qtv.sh
[2014-11-02@17:23:42] starting new event
QTV cfg updater by d2@tdhack.com

[i] verifying your /home/users/d2/qtv/qtv/qtv.cfg file
[i] checking if /home/users/d2/qtv/qtv.bin exists
[i] checking if /home/users/d2/qtvbackup exists
[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/servers/servers.txt
        [+] backup of existing file
        [+] preparing input data
        [+] compiling new /home/users/d2/qtv/qtv/qtv.cfg
        [+] cleaning tmp files
        [+] restarting qtv
                [i] running qtv found, PID: 6603, killing it now!
[i] checking crontab entry
        [+] OK, crontab is present
[2014-11-02@17:23:42] end
```
### installation
make sure to replace $HOME with something meaningful, like: /home/d2/

* cd $HOME
* git clone https://github.com/d2-d2/qtvcfg
* chmod 755 $HOME/qtvcfg/qtv.sh

### todo

### Ideas? Reports?

Send them to: d2@tdhack.com
