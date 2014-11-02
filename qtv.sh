#!/bin/bash

#### CFG section starts here
version=0.2
LOGFILE=${0}.log
# define pipe-delimited exclude list for quake servers
EXCLUDELIST="QFWD|FWD"
# dedicated backup directory for qtv.cfg files
BACKUPDIR=/full/path/to/backup/dir
# paste full path to your qtv.cfg here, please make sure it have: # servers to monitor markup.
# otherwise this script will fail to update it. Example syntax:
# [...]
# # servers to monitor
# qtv miami.usa.besmella.com:28501
# qtv miami.usa.besmella.com:28502
QTVFILE=/full/path/to/qtv.cfg
# working QTV binary
QTVBIN=/full/path/to/qtv.bin
# URL containing updated list of quake servers (ip:port format), you can have more than one, space-delimited URLs
UPDATEURL="http://www.quakeservers.net/lists/servers/servers.txt"
# attemt to restart QTV binary automatically
QTVAUTORESTART=1
#### CFG section ended - please do not change anything below this line ####

echo -e "[`date +%Y-%m-%d@%H:%M:%S`] starting new event" | tee -a ${LOGFILE}
echo -e "QTV cfg updater by d2@tdhack.com\n" | tee -a ${LOGFILE}

# before we do anything, let's check qtv.cfg presence and format, then qtv binary readiness
echo -e "[i] verifying your ${QTVFILE} file" | tee -a ${LOGFILE}
if [[ ! -e ${QTVFILE} ]]; then
    echo -e "\t[-] unable to find ${QTVFILE} file. Aborting." | tee -a ${LOGFILE}
    echo -e "[`date +%Y-%m-%d@%H:%M:%S`] end" | tee -a ${LOGFILE}
    exit 1
fi
if [[ `grep '# servers to monitor' ${QTVFILE}` == "" ]]; then
    echo -e "\t[-] ${QTVFILE} exists but it does not contain: '# servers to monitor' marker. No action taken" | tee -a ${LOGFILE}
    echo -e "[`date +%Y-%m-%d@%H:%M:%S`] end" | tee -a ${LOGFILE}
    exit 1
fi
echo -e "[i] checking if ${QTVBIN} exists" | tee -a ${LOGFILE}
if [[ ! -e ${QTVBIN} ]]; then
    echo -e "\t[-] ${QTVBIN} not present in given path, autorestart disabled"
    QTVAUTORESTART=0
fi
echo -e "[i] checking if ${BACKUPDIR} exists" | tee -a ${LOGFILE}
if [[ ! -e ${BACKUPDIR} ]]; then
    echo -e "\t[-] ${BACKUPDIR} not present, qtv.cfg will be backed up in existing location"
    BACKUPDIR=""
fi

# get most recent list of Quake servers
for servers in ${UPDATEURL}; do
    echo -e "[i] getting fresh copy of servers.txt file from ${servers}" | tee -a ${LOGFILE}
    wget -q ${UPDATEURL} -O /tmp/servers.txt
    if [[ ${?} != 0 ]]; then
        echo -e "\t[-] unable to get servers.txt from ${UPDATEURL}" | tee -a ${LOGFILE}
    fi
    grep "" /tmp/servers.txt | grep -vE "(${EXCLUDELIST})" | awk '{print $1}' >> /tmp/servers_tmp.txt
    rm /tmp/servers.txt
done

if [[ `grep -v ^$ /tmp/servers_tmp.txt` = "" ]]; then
    echo -e "\t[-] /tmp/servers_tmp.txt is empty, nothing to update. Aborting" | tee -a ${LOGFILE}
    echo -e "[`date +%Y-%m-%d@%H:%M:%S`] end" | tee -a ${LOGFILE}
    exit 1
fi

echo -e "\t[+] backup of existing file" | tee -a ${LOGFILE}
if [[ ${BACKUPDIR} != "" ]]; then
    cp -pr ${QTVFILE} ${BACKUPDIR}/`basename ${QTVFILE}`_`date +%Y-%m-%d@%H:%M:%S`
else
    cp -pr ${QTVFILE}{,_`date +%Y-%m-%d@%H:%M:%S`}
fi
echo -e "\t[+] preparing input data" | tee -a ${LOGFILE}
sed "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`d" ${QTVFILE} | awk '{print $2}' >> /tmp/servers_tmp.txt
cat /tmp/servers_tmp.txt | sort -r | uniq > /tmp/servers.txt
sed -n "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`p" ${QTVFILE} > /tmp/servers_qtv.cfg
echo -e "\n" >> /tmp/servers_qtv.cfg
cat /tmp/servers.txt | grep -v ^$ | sed -e 's,^,qtv ,g' >> /tmp/servers_qtv.cfg
echo -e "\t[+] compiling new ${QTVFILE}" | tee -a ${LOGFILE}
mv /tmp/servers_qtv.cfg ${QTVFILE}
echo -e "\t[+] cleaning tmp files" | tee -a ${LOGFILE}
rm /tmp/servers_qtv.cfg /tmp/servers_tmp.txt /tmp/servers.txt 2>/dev/null
THISSCRIPTNAME=`basename ${0}`
THISSCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THISQTVBIN=`basename ${QTVBIN}`
if [[ ${QTVAUTORESTART} = 1 ]]; then
    echo -e "\t[+] restarting qtv"
    QTVPID="`ps axwww | grep -v grep | grep ${THISQTVBIN} | awk '{print $1}'`"
    if [[ ${QTVPID} != "" ]]; then
        echo -e "\t\t[i] running qtv found, PID: ${QTVPID}, killing it now!"
        kill -9 ${QTVPID}
    fi
    cd `dirname ${QTVBIN}`
    nohup ${QTVBIN} > /dev/null 2>&1 &
else
    echo -e "[*] done, restart your qtv manually" | tee -a ${LOGFILE}
fi
echo -e "[i] checking crontab entry"
if [[ `crontab -l | grep ${THISSCRIPTNAME}` = "" ]]; then
    echo -e "\t[-] FAIL, crontab not present, adding one for you"
    crontab -l > /tmp/crontab_tmp
    echo "0 0 * * * ${THISSCRIPTDIR}/${THISSCRIPTNAME} > /dev/null 2>&1" >> /tmp/crontab_tmp
    crontab /tmp/crontab_tmp
    rm /tmp/crontab_tmp 2>/dev/null
else
    echo -e "\t[+] OK, crontab is present"
fi
echo -e "[`date +%Y-%m-%d@%H:%M:%S`] end" | tee -a ${LOGFILE}
