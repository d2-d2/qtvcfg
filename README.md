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
[2014-11-03@16:45:24] starting new event
QTV cfg updater by d2@tdhack.com

[i] verifying your /home/users/d2/qtv/qtv/qtv.cfg file
[i] checking if /home/users/d2/qtv/qtv.bin exists
[i] checking if /home/users/d2/qtvbackup exists
        [-] /home/users/d2/qtvbackup not present, qtv.cfg will be backed up in existing location
[i] getting fresh copy of servers.txt file from http://www.quakeservers.net/lists/servers/servers.txt
[+] checking QW servers (303 in initial list)
        [9/303] 108.61.223.230:30000 not a QW server
        [15/303] 54.79.51.12:27500 not responding to Cmd_ping
        [19/303] 54.79.51.12:30000 not a QW server
        [22/303] 190.14.56.198:30000 not a QW server
        [27/303] 181.41.214.162:30000 not a QW server
        [28/303] 95.31.4.132:30000 not a QW server
        [30/303] 75.109.153.194:27500 not a QW server
        [34/303] 74.91.114.207:30000 not a QW server
        [43/303] 82.141.152.3:27502 not a QW server
        [47/303] 46.165.219.134:30000 not a QW server
        [51/303] 88.198.221.98:30000 not a QW server
        [61/303] 212.13.203.166:28000 not a QW server
        [63/303] 213.133.100.142:27599 not responding to Cmd_ping
        [70/303] 94.137.97.57:28000 not a QW server
        [76/303] 85.196.7.34:30000 not a QW server
        [85/303] 24.73.154.245:30000 not a QW server
        [87/303] 54.92.39.77:30000 not a QW server
        [92/303] 78.137.161.109:30000 not a QW server
        [97/303] 23.239.134.33:27500 not responding to Cmd_ping
        [98/303] 23.239.134.33:30000 not a QW server
        [104/303] 5.101.102.117:27500 not responding to Cmd_ping
        [109/303] 5.101.102.117:30000 not a QW server
        [110/303] 23.239.134.165:27500 not responding to Cmd_ping
        [113/303] 23.239.134.165:30000 not a QW server
        [117/303] 95.143.243.24:27900 not responding to Cmd_ping
        [118/303] 212.42.38.88:30000 not a QW server
        [124/303] 46.254.17.216:1 not a QW server
        [125/303] 212.13.203.166:27666 not responding to Cmd_ping
        [126/303] 93.81.254.63:30001 not responding to Cmd_ping
        [143/303] 5.101.102.117:28000 not a QW server
        [144/303] 179.43.123.65:28501 not responding to Cmd_ping
        [145/303] 179.43.123.65:28502 not responding to Cmd_ping
        [146/303] 179.43.123.65:30000 not responding to Cmd_ping
        [151/303] 200.98.128.244:28000 not a QW server
        [170/303] 81.4.126.69:28000 not a QW server
        [171/303] 81.4.126.69:30000 not a QW server
        [176/303] 212.13.203.167:30000 not a QW server
        [177/303] 217.119.36.79:28000 not a QW server
        [178/303] 217.119.36.79:30000 not a QW server
        [184/303] 46.72.215.210:28000 not a QW server
        [195/303] 46.41.128.212:30000 not a QW server
        [198/303] 160.79.125.19:30001 not responding to Cmd_ping
        [199/303] 160.79.125.19:29000 not a QW server
        [205/303] 46.246.119.106:30000 not a QW server
        [211/303] 91.121.69.201:30000 not a QW server
        [212/303] 94.236.92.49:30000 not a QW server
        [214/303] 203.143.83.59:27500 not a QW server
        [215/303] 37.123.186.135:30000 not a QW server
        [216/303] 69.64.50.237:27500 not a QW server
        [220/303] 92.243.0.251:30000 not a QW server
        [221/303] 198.211.125.157:30000 not a QW server
        [226/303] 54.215.254.93:27500 not responding to Cmd_ping
        [229/303] 54.215.254.93:30000 not a QW server
        [233/303] 109.229.162.150:30000 not a QW server
        [239/303] 78.140.5.25:30000 not a QW server
        [248/303] 88.150.212.66:27500 not a QW server
        [253/303] 194.79.85.66:30000 not a QW server
        [262/303] 84.34.166.158:30000 not a QW server
        [266/303] 194.109.69.76:30000 not a QW server
        [267/303] 93.81.254.63:30000 not a QW server
        [271/303] 37.46.187.230:28501 not a QW server
        [273/303] 85.235.251.94:30000 not a QW server
        [277/303] 23.244.69.195:27500 not responding to Cmd_ping
        [278/303] 23.244.69.195:30000 not a QW server
        [280/303] 46.173.34.252:30000 not a QW server
        [288/303] 194.109.69.75:28000 not responding to Cmd_ping
        [293/303] 146.185.151.224:30000 not a QW server
        [301/303] 91.121.69.201:27600 not responding to Cmd_ping
        [i] done, 492 in the list
        [+] backup of existing file
        [+] preparing input data
        [+] compiling new /home/users/d2/qtv/qtv/qtv.cfg
        [+] cleaning tmp files
        [+] restarting qtv
[i] checking crontab entry
        [-] FAIL, crontab not present, adding one for you
[2014-11-03@17:05:48] end
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
