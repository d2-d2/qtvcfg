#!/bin/bash

# paste full path to your qtv.cfg here, please make sure it have: # servers to monitor markup.
# otherwise this script will fail to update it. Example syntax:
# [...]
# # servers to monitor
# qtv miami.usa.besmella.com:28501
# qtv miami.usa.besmella.com:28502
QTVFILE=/full/path/to/qtv.cfg
# URL containing updated list of quake servers (ip:port format)
UPDATEURL="
http://www.quakeservers.net/lists/servers/servers.txt
http://www.quakeservers.net/lists/north_america/servers.txt
"

echo -e "QTV cfg updater by d2@tdhack.com\n"

for servers in ${UPDATEURL}; do
    echo -e "[i] getting fresh copy of servers.txt file from ${servers}"
    wget -q ${UPDATEURL} -O /tmp/servers.txt
    if [[ ${?} != 0 ]]; then
        echo -e "\t[-] unable to get servers.txt from ${UPDATEURL}"
        exit 1
    fi
    grep "" /tmp/servers.txt | awk '{print $1}' >> /tmp/servers_tmp.txt
done

echo -e "[i] verifying your ${QTVFILE} file"
if [[ -e ${QTVFILE} ]]; then
    if [[ `grep '# servers to monitor' ${QTVFILE}` != "" ]]; then
        echo -e "\t[+] backup of existing file"
        cp -pr ${QTVFILE}{,_`date +%Y-%m-%d@%H:%M:%S`}
        echo -e "\t[+] preparing input data"
        sed "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`d" ${QTVFILE} | awk '{print $2}' >> /tmp/servers_tmp.txt
        cat /tmp/servers_tmp.txt | sort -r | uniq > /tmp/servers.txt
        sed -n "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`p" ${QTVFILE} > /tmp/servers_qtv.cfg
        echo -e "\n" >> /tmp/servers_qtv.cfg
        cat /tmp/servers.txt | grep -v ^$ | sed -e 's,^,qtv ,g' >> /tmp/servers_qtv.cfg
        echo -e "\t[+] compiling new ${QTVFILE}"
        mv /tmp/servers_qtv.cfg ${QTVFILE}
        echo -e "\t[+] cleaning tmp files"
        rm /tmp/servers_qtv.cfg /tmp/servers_tmp.cfg /tmp/servers.txt 2>/dev/null
        echo -e "[*] done, restart qtv manually"
    else
        echo -e "\t[-] ${QTVFILE} exists but it does not contain: '# servers to monitor' marker. No action taken"
        exit 1
    fi
else
    echo -e "\t[-] unable to find ${QTVFILE} file. Aborting."
    exit 1
fi
