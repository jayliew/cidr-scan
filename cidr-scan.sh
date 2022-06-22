#!/bin/bash

# Please send feedback and bugs to Jay

# user must supply args
if [ $# -lt 1 ] ; then echo 'Usage: ./cidr-scan.sh 1.2.3.4/26 "optional: port range (in quotes)"' ; exit 1 ; fi
IP_CIDR=$1
PORTS=$2

# Default port range if not specified
if [ -z "$PORTS" ] ; then PORTS="21-23 80" ; fi

# IP_CIDR='1.1.1.180/26'
IP=$(echo $IP_CIDR | cut -d '/' -f 1)
CIDR=$(echo $IP_CIDR | cut -d '/' -f 2)
OCTET_4=$(echo $IP | cut -d '.' -f 4)
NET_ADDR=$(echo $IP | cut -d '.' -f 1,2,3)

if [[ $IP_CIDR != *"/"* ]]; then
    # if no cidr, assume /32
    CIDR=32
fi

if [ $CIDR -eq 31 ] || [ $CIDR -lt 24 ] ; then
    echo "Invalid / unsupported CIDR"
    exit
fi

declare -A CIDR_DIV_DENOM # denominator in division
CIDR_DIV_DENOM[24]=256
CIDR_DIV_DENOM[25]=128 # num of IPs per range, including broadcast and network ID
CIDR_DIV_DENOM[26]=64
CIDR_DIV_DENOM[27]=32
CIDR_DIV_DENOM[28]=16
CIDR_DIV_DENOM[29]=8
CIDR_DIV_DENOM[30]=4

ARR_INDEX=-1 # init with invalid value to be changed
if [ $CIDR -eq 32 ] ; 
    then
        ARR_INDEX='ONE_IP_ONLY' # edge case
    else
    ARR_INDEX_SUFFIX=$(($OCTET_4/${CIDR_DIV_DENOM[$CIDR]}))
    ARR_INDEX_PREFIX=$CIDR
    ARR_INDEX="${ARR_INDEX_PREFIX}_$ARR_INDEX_SUFFIX"
fi

# echo $ARR_INDEX

declare -A IP_RANGE

IP_RANGE[ONE_IP_ONLY]="${OCTET_4} ${OCTET_4}"

# start and end IP range for /24, excluding broadcast & network ID
IP_RANGE[24_0]="1 254"

# start and end IP range for /25, excluding broadcast & network ID
IP_RANGE[25_0]="1 126"
IP_RANGE[25_1]="129 254"

# start and end IP range for /26, excluding broadcast & network ID
IP_RANGE[26_0]="1 62"
IP_RANGE[26_1]="65 126"
IP_RANGE[26_2]="129 190"
IP_RANGE[26_3]="193 254"

# start and end IP range for /27, excluding broadcast & network ID
IP_RANGE[27_0]="1 30"
IP_RANGE[27_1]="33 62"
IP_RANGE[27_2]="65 94"
IP_RANGE[27_3]="97 126"
IP_RANGE[27_4]="129 158"
IP_RANGE[27_5]="161 190"
IP_RANGE[27_6]="193 222"
IP_RANGE[27_7]="225 254"

# start and end IP range for /28, excluding broadcast & network ID
IP_RANGE[28_0]="1 14"
IP_RANGE[28_1]="17 30"
IP_RANGE[28_2]="33 46"
IP_RANGE[28_3]="49 62"
IP_RANGE[28_4]="65 78"
IP_RANGE[28_5]="81 94"
IP_RANGE[28_6]="97 110"
IP_RANGE[28_7]="113 126"
IP_RANGE[28_8]="129 142"
IP_RANGE[28_9]="145 158"
IP_RANGE[28_10]="161 174"
IP_RANGE[28_11]="177 190"
IP_RANGE[28_12]="193 206"
IP_RANGE[28_13]="209 222"
IP_RANGE[28_14]="225 238"
IP_RANGE[28_15]="241 254"

# start and end IP range for /29, excluding broadcast & network ID
IP_RANGE[29_0]="1 6"
IP_RANGE[29_1]="9 14"
IP_RANGE[29_2]="17 22"
IP_RANGE[29_3]="25 30"
IP_RANGE[29_4]="33 38"
IP_RANGE[29_5]="41 46"
IP_RANGE[29_6]="49 54"
IP_RANGE[29_7]="57 62"
IP_RANGE[29_8]="65 70"
IP_RANGE[29_9]="73 78"
IP_RANGE[29_10]="81 86"
IP_RANGE[29_11]="89 94"
IP_RANGE[29_12]="97 102"
IP_RANGE[29_13]="105 110"
IP_RANGE[29_14]="113 118"
IP_RANGE[29_15]="121 126"
IP_RANGE[29_16]="129 134"
IP_RANGE[29_17]="137 142"
IP_RANGE[29_18]="145 150"
IP_RANGE[29_19]="153 158"
IP_RANGE[29_20]="161 166"
IP_RANGE[29_21]="169 174"
IP_RANGE[29_22]="177 182"
IP_RANGE[29_23]="185 190"
IP_RANGE[29_24]="193 198"
IP_RANGE[29_25]="201 206"
IP_RANGE[29_26]="209 214"
IP_RANGE[29_27]="217 222"
IP_RANGE[29_28]="225 230"
IP_RANGE[29_29]="233 238"
IP_RANGE[29_30]="241 246"
IP_RANGE[29_31]="249 254"

# start and end IP range for /30, excluding broadcast & network ID
IP_RANGE[30_0]="1 2"
IP_RANGE[30_1]="5 6"
IP_RANGE[30_2]="9 10"
IP_RANGE[30_3]="13 14"
IP_RANGE[30_4]="17 18"
IP_RANGE[30_5]="21 22"
IP_RANGE[30_6]="25 26"
IP_RANGE[30_7]="29 30"
IP_RANGE[30_8]="33 34"
IP_RANGE[30_9]="37 38"
IP_RANGE[30_10]="41 42"
IP_RANGE[30_11]="45 46"
IP_RANGE[30_12]="49 50"
IP_RANGE[30_13]="53 54"
IP_RANGE[30_14]="57 58"
IP_RANGE[30_15]="61 62"
IP_RANGE[30_16]="65 66"
IP_RANGE[30_17]="69 70"
IP_RANGE[30_18]="73 74"
IP_RANGE[30_19]="77 78"
IP_RANGE[30_20]="81 82"
IP_RANGE[30_21]="85 86"
IP_RANGE[30_22]="89 90"
IP_RANGE[30_23]="93 94"
IP_RANGE[30_24]="97 98"
IP_RANGE[30_25]="101 102"
IP_RANGE[30_26]="105 106"
IP_RANGE[30_27]="109 110"
IP_RANGE[30_28]="113 114"
IP_RANGE[30_29]="117 118"
IP_RANGE[30_30]="121 122"
IP_RANGE[30_31]="125 126"
IP_RANGE[30_32]="129 130"
IP_RANGE[30_33]="133 134"
IP_RANGE[30_34]="137 138"
IP_RANGE[30_35]="141 142"
IP_RANGE[30_36]="145 146"
IP_RANGE[30_37]="149 150"
IP_RANGE[30_38]="153 154"
IP_RANGE[30_39]="157 158"
IP_RANGE[30_40]="161 162"
IP_RANGE[30_41]="165 166"
IP_RANGE[30_42]="169 170"
IP_RANGE[30_43]="173 174"
IP_RANGE[30_44]="177 178"
IP_RANGE[30_45]="181 182"
IP_RANGE[30_46]="185 186"
IP_RANGE[30_47]="189 190"
IP_RANGE[30_48]="193 194"
IP_RANGE[30_49]="197 198"
IP_RANGE[30_50]="201 202"
IP_RANGE[30_51]="205 206"
IP_RANGE[30_52]="209 210"
IP_RANGE[30_53]="213 214"
IP_RANGE[30_54]="217 218"
IP_RANGE[30_55]="221 222"
IP_RANGE[30_56]="225 226"
IP_RANGE[30_57]="229 230"
IP_RANGE[30_58]="233 234"
IP_RANGE[30_59]="237 238"
IP_RANGE[30_60]="241 242"
IP_RANGE[30_61]="245 246"
IP_RANGE[30_62]="249 250"
IP_RANGE[30_63]="253 254"

# start and end IP range for /32 (itself)
IP_RANGE[32_1]="${OCTET_4} ${OCTET_4}"

# echo $ARR_INDEX
# echo ${IP_RANGE[$ARR_INDEX]}

OCTET_4_RANGE=(${IP_RANGE[$ARR_INDEX]})
OCTET_4_START=${OCTET_4_RANGE[0]}
OCTET_4_STOP=${OCTET_4_RANGE[1]}
# echo "start $OCTET_4_START"
# echo "stop $OCTET_4_STOP"

echo "Scanning ${NET_ADDR}.${OCTET_4_START}-${OCTET_4_STOP} on ports ${PORTS}:"

for ((I=$OCTET_4_START; $I<=$OCTET_4_STOP; I++))
do
    # timeout 0.2 nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Rr]efuse$'
    # timeout 0.3 nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Ss]ucce$'
    nc -nvzw1 $NET_ADDR.$I $PORTS 2>&1 | grep -E '[Oo]pen|[Ss]ucce$'
done

