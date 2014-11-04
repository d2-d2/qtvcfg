# WTF?

shell script to update qtv.cfg files

### Requirements

* bash
* wget
* sed
* git
* nohup
### Initial configuration

Before you run this script, please open it and configure following variables:
- BACKUPDIR
- QTVFILE
- QTVBIN
- UPDATEURL
- QTVAUTORESTART
- README

### Example outputs:
```
# ./qtv.sh
[2014-11-03@23:14:02] starting new event
QTV cfg updater by d2@tdhack.com

[i] verifying your /home/users/d2/qtv/qtv/qtv.cfg file
[i] checking if /home/users/d2/qtv/qtv.bin exists
[i] checking if /home/users/d2/qtvbackup exists
        [-] /home/users/d2/qtvbackup not present, qtv.cfg will be backed up in existing location
[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/servers/servers.txt
[+] checking QW servers (300 in initial list), check ./qtv.sh.err for details
        [9/300] 108.61.223.230:30000 not a QW server
        [15/300] 54.79.51.12:27500 not responding to Cmd_ping
        [19/300] 54.79.51.12:30000 not a QW server
        [22/300] 190.14.56.198:30000 not a QW server
        [26/300] 181.41.214.162:28100 not a QW server
        [27/300] 181.41.214.162:30000 not a QW server
        [28/300] 95.31.4.132:30000 not a QW server
        [30/300] 75.109.153.194:27500 not a QW server
        [34/300] 74.91.114.207:30000 not a QW server
        [43/300] 82.141.152.3:27502 not a QW server
        [47/300] 46.165.219.134:30000 not a QW server
        [51/300] 88.198.221.98:30000 not a QW server
        [61/300] 212.13.203.166:28000 not a QW server
        [63/300] 213.133.100.142:27599 not responding to Cmd_ping
        [70/300] 94.137.97.57:28000 not a QW server
        [76/300] 85.196.7.34:30000 not a QW server
        [85/300] 24.73.154.245:30000 not a QW server
        [87/300] 54.92.39.77:30000 not a QW server
        [92/300] 78.137.161.109:30000 not a QW server
        [97/300] 23.239.134.33:27500 not responding to Cmd_ping
        [98/300] 23.239.134.33:30000 not a QW server
        [104/300] 5.101.102.117:27500 not responding to Cmd_ping
        [109/300] 5.101.102.117:30000 not a QW server
        [114/300] 95.143.243.24:27900 not responding to Cmd_ping
        [115/300] 212.42.38.88:30000 not a QW server
        [121/300] 46.254.17.216:1 not a QW server
        [122/300] 212.13.203.166:27666 not responding to Cmd_ping
        [123/300] 93.81.254.63:30001 not responding to Cmd_ping
        [140/300] 5.101.102.117:28000 not a QW server
        [143/300] 179.43.123.65:30000 not a QW server
        [148/300] 200.98.128.244:28000 not a QW server
        [167/300] 81.4.126.69:28000 not a QW server
        [168/300] 81.4.126.69:30000 not a QW server
        [173/300] 212.13.203.167:30000 not a QW server
        [174/300] 217.119.36.79:28000 not a QW server
        [175/300] 217.119.36.79:30000 not a QW server
        [181/300] 46.72.215.210:28000 not a QW server
        [192/300] 46.41.128.212:30000 not a QW server
        [195/300] 160.79.125.19:30001 not responding to Cmd_ping
        [196/300] 160.79.125.19:29000 not a QW server
        [202/300] 46.246.119.106:30000 not a QW server
        [208/300] 91.121.69.201:30000 not a QW server
        [209/300] 94.236.92.49:30000 not a QW server
        [211/300] 203.143.83.59:27500 not a QW server
        [212/300] 37.123.186.135:30000 not a QW server
        [213/300] 69.64.50.237:27500 not a QW server
        [217/300] 92.243.0.251:30000 not a QW server
        [218/300] 198.211.125.157:30000 not a QW server
        [223/300] 54.215.254.93:27500 not responding to Cmd_ping
        [226/300] 54.215.254.93:30000 not a QW server
        [230/300] 109.229.162.150:30000 not a QW server
        [236/300] 78.140.5.25:30000 not a QW server
        [245/300] 88.150.212.66:27500 not a QW server
        [250/300] 194.79.85.66:30000 not a QW server
        [259/300] 84.34.166.158:30000 not a QW server
        [263/300] 194.109.69.76:30000 not a QW server
        [264/300] 93.81.254.63:30000 not a QW server
        [267/300] 37.46.187.230:28501 not a QW server
        [269/300] 85.235.251.94:30000 not a QW server
        [273/300] 23.244.69.195:27500 not responding to Cmd_ping
        [274/300] 23.244.69.195:30000 not a QW server
        [276/300] 46.173.34.252:30000 not a QW server
        [284/300] 194.109.69.75:28000 not responding to Cmd_ping
        [289/300] 146.185.151.224:30000 not a QW server
        [298/300] 91.121.69.201:27600 not responding to Cmd_ping
        [i] done, 243 servers in the final list
[i] backup of existing file
[i] preparing input data
[i] compiling new /home/users/d2/qtv/qtv/qtv.cfg
[i] cleaning tmp files
[+] restarting qtv
[i] checking crontab entry
        [-] FAIL, crontab not present, adding one for you
[2014-11-03@23:34:28] end
```
### installation
make sure to replace $HOME with something meaningful, like: /home/d2/

* cd $HOME
* git clone https://github.com/d2-d2/qtvcfg
* chmod 755 $HOME/qtvcfg/qtv.sh

### todo
* speed up execution of this script (it takes 20minutes to complete run on 235 servers)

### Ideas? Reports?

Send them to: d2@tdhack.com
