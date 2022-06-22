#!/bin/bash
# Please send feedback and bugs to Jay

# user must supply args
if [ $# -lt 1 ] ; then echo 'Usage: ./cidr-scan.sh 1.2.3.4/26 "optional: port range (in quotes)"' ; exit 1 ; fi
IP_CIDR=$1
PORTS=$2

if [ -z "$PORTS" ] ; then PORTS="21-23 80" ; fi # Default port range if not specified

IP=$(echo $IP_CIDR | cut -d '/' -f 1)
CIDR=$(echo $IP_CIDR | cut -d '/' -f 2)
OCTET_4=$(echo $IP | cut -d '.' -f 4)
NET_ADDR=$(echo $IP | cut -d '.' -f 1,2,3)

if [[ $IP_CIDR != *"/"* ]]; then
    CIDR=32 # if no cidr, assume /32
fi

if [ $CIDR -eq 31 ] || [ $CIDR -lt 24 ] ; then
    echo "Invalid / unsupported CIDR" ; exit
fi

declare -A CIDR_DIV_DENOM # denominator in division
CIDR_DIV_DENOM[24]=256
CIDR_DIV_DENOM[25]=128 # num of IPs per range, 
CIDR_DIV_DENOM[26]=64 # including broadcast and network ID
CIDR_DIV_DENOM[27]=32
CIDR_DIV_DENOM[28]=16
CIDR_DIV_DENOM[29]=8
CIDR_DIV_DENOM[30]=4

if [ $CIDR -ne 32 ] ; then
    IP_ADDRS_PER_SUBNET=${CIDR_DIV_DENOM[$CIDR]}
    # echo "IP_ADDRS_PER_SUBNET: ${IP_ADDRS_PER_SUBNET}"

    OFFSET_START=$(( $OCTET_4/$IP_ADDRS_PER_SUBNET ))
    # echo "OFFSET_START: ${OFFSET_START}"

    OFFSET_STOP=$(( $OCTET_4/$IP_ADDRS_PER_SUBNET+1 ))
    # echo "OFFSET_STOP: ${OFFSET_STOP}"

    OCTET_4_START=$(( $OFFSET_START*$IP_ADDRS_PER_SUBNET+1 ))
    OCTET_4_STOP=$(( $OFFSET_STOP*$IP_ADDRS_PER_SUBNET-2 ))
else 
    OCTET_4_START=$OCTET_4
    OCTET_4_STOP=$OCTET_4
fi

echo "Scanning ${NET_ADDR}.${OCTET_4_START}-${OCTET_4_STOP} on ports ${PORTS}:"

for ((I=$OCTET_4_START; $I<=$OCTET_4_STOP; I++))
do
    # timeout 0.3 nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Rr]efuse$'
    # timeout 0.3 nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Ss]ucce$'
    nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Ss]ucce$'
done

