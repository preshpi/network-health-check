#!/bin/bash

REPORT_FILE="network_report.txt"

# Clear old report
echo "NETWORK HEALTH REPORT" > $REPORT_FILE
echo "=====================" >> $REPORT_FILE

# Function to display and save output
log() {
    echo "$1"
    echo "$1" >> $REPORT_FILE
}

log ""
log "1. SERVER INFORMATION"
log "----------------------"
log "Hostname: $(hostname)"
log "Current User: $(whoami)"
log "Date and Time: $(date)"

log ""
log "2. NETWORK INFORMATION"
log "----------------------"

IP_ADDRESS=$(hostname -I | awk '{print $1}')
DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
DNS_SERVER=$(grep "nameserver" /etc/resolv.conf | head -1 | awk '{print $2}')

log "IP Address: $IP_ADDRESS"
log "Default Gateway: $DEFAULT_GATEWAY"
log "DNS Server: $DNS_SERVER"

log ""
log "3. INTERNET CONNECTIVITY"
log "-------------------------"

if ping -c 4 8.8.8.8 > /dev/null 2>&1
then
    log "Internet Connectivity: UP"
else
    log "Internet Connectivity: DOWN"
fi

log ""
log "4. DNS RESOLUTION"
log "------------------"

if nslookup google.com > /dev/null 2>&1
then
    log "DNS Resolution: WORKING"
else
    log "DNS Resolution: FAILED"
fi

log ""
log "5. WEBSITE AVAILABILITY"
log "------------------------"

for site in google.com github.com amazon.com
do
    if ping -c 2 $site > /dev/null 2>&1
    then
        log "$site : UP"
    else
        log "$site : DOWN"
    fi
done

log ""
log "Report generated successfully: $REPORT_FILE"
