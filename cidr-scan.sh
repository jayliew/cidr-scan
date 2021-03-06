#!/bin/bash
# Please send feedback and bugs to Jay

if [ $# -lt 1 ] ; then echo 'Usage: ./cidr-scan.sh 1.2.3.4/26 "optional: port range (in quotes)"' ; exit 1 ; fi
IP_CIDR=$1
PORTS=$2

if [ -z "$PORTS" ] ; then PORTS="21-23 80" ; fi # default port range

IP=$(echo $IP_CIDR | cut -d '/' -f 1)
CIDR=$(echo $IP_CIDR | cut -d '/' -f 2)
OCTET_4=$(echo $IP | cut -d '.' -f 4)
NET_ADDR=$(echo $IP | cut -d '.' -f 1,2,3)

if [[ $IP_CIDR != *"/"* ]]; then CIDR=32 ; fi # if no cidr, assume /32

if [ $CIDR -eq 31 ] || [ $CIDR -lt 24 ] || [ $CIDR -gt 32 ] ; then echo "Invalid / unsupported CIDR" ; exit ; fi

if [ $CIDR -ne 32 ] ; then
    IP_ADDRS_PER_SUBNET=$(( 2**(32-CIDR) ))
    OFFSET_START=$(( $OCTET_4/$IP_ADDRS_PER_SUBNET ))
    OFFSET_STOP=$(( $OCTET_4/$IP_ADDRS_PER_SUBNET+1 ))
    OCTET_4_START=$(( $OFFSET_START*$IP_ADDRS_PER_SUBNET+1 ))
    OCTET_4_STOP=$(( $OFFSET_STOP*$IP_ADDRS_PER_SUBNET-2 )) 
else 
    OCTET_4_START=$OCTET_4
    OCTET_4_STOP=$OCTET_4
fi

echo "Scanning ${NET_ADDR}.${OCTET_4_START}-${OCTET_4_STOP} on ports ${PORTS}:"

MOD_VAR=1000
if [ $CIDR -eq 24 ]; then MOD_VAR=10 ; fi # show progress when scanning /24

for ((I=$OCTET_4_START; $I<=$OCTET_4_STOP; I++))
do
    # comment out next 2 lines to show progress when scanning a /24
    # TMP_VAR=$(( $I % $MOD_VAR ))
    # if [ $TMP_VAR -eq 0 ]; then echo "scanning .${I}" ; fi

    # timeout 0.3 nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Rr]efuse'
    nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Ss]ucce' & # remove the ampersand & to remove backgrounding
done

