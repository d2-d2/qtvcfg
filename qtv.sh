#!/bin/bash

#### CFG section starts here
version=0.4
# define pipe-delimited exclude list for quake servers
EXCLUDELIST="QFWD|FWD"
# dedicated backup directory for qtv.cfg files
BACKUPDIR=/home/users/d2/qtvbackup
# paste full path to your qtv.cfg here, please make sure it have: # servers to monitor markup.
# otherwise this script will fail to update it. Example syntax:
# [...]
# # servers to monitor
# qtv miami.usa.besmella.com:28501
# qtv miami.usa.besmella.com:28502
QTVFILE=/home/users/d2/qtv/qtv/qtv.cfg
# working QTV binary
QTVBIN=/home/users/d2/qtv/qtv.bin
# URL containing updated list of quake servers (ip:port format), you can have more than one, space-delimited URLs
UPDATEURL="http://www.quakeservers.net/lists/servers/servers.txt"
# attemt to restart QTV binary automatically
QTVAUTORESTART=1
#### CFG section ended - please do not change anything below this line ####

THISSCRIPTNAME=`basename ${0}`
THISSCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
THISQTVBIN=`basename ${QTVBIN}`
THISSCRIPTPID="$$"
THISLOCKFILE=/tmp/${THISSCRIPTNAME}.lock
LOGFILE=${THISSCRIPTDIR}/${THISSCRIPTNAME}.log
LOGERR=${THISSCRIPTDIR}/${THISSCRIPTNAME}.err

cat /dev/null >> ${THISLOCKFILE}
read lastPID < ${THISLOCKFILE}
if [[ (! -z "${lastPID}") && (-d /proc/${lastPID}) ]]; then
    echo -e "[-] script is already running, PID: ${lastPID}"
    exit 1
else
    echo ${THISSCRIPTPID} > ${THISLOCKFILE}
fi

function sk_checkquakeserver(){
    known_server_strings="(MVDSV|FTE|CPQWSV|ZQuake)"
    srv_data=${1}
    s_ip=`echo ${srv_data} | cut -d: -f1`
    s_port=`echo ${srv_data} | cut -d: -f2`
    sv_ping=$(printf "\xff\xff\xff\xff ping" | nc -w 1 -u ${s_ip} ${s_port})
    if [[  ${sv_ping} != "" ]]; then
        sv_version=$(printf "\xff\xff\xff\xff status" | nc -w 1 -u ${s_ip} ${s_port} | cut -d\\ -f2- | awk '{
            for (i = 0; ++i <=NF;)
                if ($i == o)
                    ++C % c || $i = n 
        } 1' FS= OFS= c=2 o=\\ n="\n" | tr '\\' '=' 2> /dev/null | grep --binary-files=text version | cut -d= -f2-)
        if [[ ${sv_version} =~ ${known_server_strings} ]]; then
            # yes, it's quakeserver
            echo 0
        else
            # nope - fwd, proxy or other
            echo 1
        fi
    else
        # server is not responding to ping
        echo 2
    fi
}

function sk_cleanup(){
    rm /tmp/servers_qtv.cfg /tmp/servers_tmp.txt /tmp/servers.txt ${LOGERR} ${THISLOCKFILE} 2>/dev/null
    touch ${LOGERR}
}

sk_cleanup

echo -e "[`date +%Y-%m-%d@%H:%M:%S`] starting new event" | tee -a ${LOGFILE}
echo -e "QTV cfg updater by d2@tdhack.com, version: ${version}\n" | tee -a ${LOGFILE}

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
    echo -e "\t[-] ${QTVBIN} not present in given path, autorestart disabled" | tee -a ${LOGFILE}
    QTVAUTORESTART=0
fi
echo -e "[i] checking if ${BACKUPDIR} exists" | tee -a ${LOGFILE}
if [[ ! -e ${BACKUPDIR} ]]; then
    echo -e "\t[-] ${BACKUPDIR} not present, qtv.cfg will be backed up in existing location" | tee -a ${LOGFILE}
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

# check qw servers
SRVTOTAL="`wc -l /tmp/servers_tmp.txt | awk '{print $1}'`"
SRVCUR=1
echo -e "[+] checking QW servers (${SRVTOTAL} in initial list), check ${0}.err for details" | tee -a ${LOGFILE}
while read svdata; do
    srv_response=$(sk_checkquakeserver ${svdata})
    case ${srv_response} in
        0)  echo "${svdata}" >> /tmp/servers_qw.txt ;;
        1)  echo -e "\t[${SRVCUR}/${SRVTOTAL}] ${svdata} not a QW server" | tee -a ${LOGFILE}
            echo -e "[`date +%Y-%m-%d@%H:%M:%S`] ${svdata} not a QW server" >> ${LOGERR}
            ;;
        2)  echo -e "\t[${SRVCUR}/${SRVTOTAL}] ${svdata} not responding to Cmd_ping" | tee -a ${LOGFILE}
            echo -e "[`date +%Y-%m-%d@%H:%M:%S`] ${svdata} not responding to Cmd_ping" >> ${LOGERR}
            ;;
    esac
    SRVCUR=$[SRVCUR+1]
done < /tmp/servers_tmp.txt
mv /tmp/servers_qw.txt /tmp/servers_tmp.txt
echo -e "\t[i] done, `wc -l /tmp/servers_tmp.txt | awk '{print $1}'` servers in the final list" | tee -a ${LOGFILE}

echo -e "[i] backup of existing file" | tee -a ${LOGFILE}
if [[ ${BACKUPDIR} != "" ]]; then
    cp -pr ${QTVFILE} ${BACKUPDIR}/`basename ${QTVFILE}`_`date +%Y-%m-%d@%H:%M:%S`
else
    cp -pr ${QTVFILE}{,_`date +%Y-%m-%d@%H:%M:%S`}
fi
echo -e "[i] preparing input data" | tee -a ${LOGFILE}
sed "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`d" ${QTVFILE} | awk '{print $2}' >> /tmp/servers_tmp.txt
cat /tmp/servers_tmp.txt | sort -r | uniq > /tmp/servers.txt
sed -n "1,`grep -n '# servers to monitor' ${QTVFILE} | cut -d: -f1`p" ${QTVFILE} > /tmp/servers_qtv.cfg
echo -e "\n" >> /tmp/servers_qtv.cfg
cat /tmp/servers.txt | grep -v ^$ | sed -e 's,^,qtv ,g' >> /tmp/servers_qtv.cfg
echo -e "[i] compiling new ${QTVFILE}" | tee -a ${LOGFILE}
mv /tmp/servers_qtv.cfg ${QTVFILE}
echo -e "[i] cleaning tmp files" | tee -a ${LOGFILE}
sk_cleanup
if [[ ${QTVAUTORESTART} = 1 ]]; then
    echo -e "[+] restarting qtv" | tee -a ${LOGFILE}
    QTVPID="`ps axwww | grep -v grep | grep ${THISQTVBIN} | awk '{print $1}'`"
    if [[ ${QTVPID} != "" ]]; then
        echo -e "\t[+] running qtv found, PID: ${QTVPID}, killing it now!" | tee -a ${LOGFILE}
        kill -9 ${QTVPID}
    fi
    cd `dirname ${QTVBIN}`
    nohup ${QTVBIN} > /dev/null 2>&1 &
else
    echo -e "[i] done, restart your qtv manually" | tee -a ${LOGFILE}
fi
echo -e "[i] checking crontab entry" | tee -a ${LOGFILE}
if [[ `crontab -l > /dev/null 2>&1; echo $?` = 0 ]]; then
    if [[ `crontab -l | grep ${THISSCRIPTNAME}` = "" ]]; then
        echo -e "\t[-] FAIL, crontab not present, adding one for you" | tee -a ${LOGFILE}
        crontab -l > /tmp/crontab_tmp
        echo "0 0 * * sat ${THISSCRIPTDIR}/${THISSCRIPTNAME} > /dev/null 2>&1" >> /tmp/crontab_tmp
        crontab /tmp/crontab_tmp
        rm /tmp/crontab_tmp 2>/dev/null
    else
        echo -e "\t[+] OK, crontab is present" | tee -a ${LOGFILE}
    fi
else
    echo -e "\t[-] crontab is not working here (problem with permissions?)" | tee -a ${LOGFILE}
fi
echo -e "[`date +%Y-%m-%d@%H:%M:%S`] end" | tee -a ${LOGFILE}
sk_cleanup
