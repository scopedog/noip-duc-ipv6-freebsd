#!/bin/sh

# Hiroshi Nishida
# Required programs: curl 

# Set your info here
interface="em0" # NIC interface eg em0
user="nishida@asusa.net" # E-mail/username
pass="no-ipahoahoman" # Password
hostname="rnci003.ddns.net" # DDNS hostname

# Interval for checking update
interval="1800" # Specify in seconds

# NO-IP server
url="https://dynupdate.no-ip.com/nic/update"
agent="Personal noip-ducv6/freebsd-v1.0"

# Initialize
lastaddr='none'
addr=''

# Function for updating
UpdateIP () {
    # Obtain my IP address from interface
    # You have to sometimes repeat it because interface may not be ready yet
    while [ x$addr = x ] 
    do
        # Get valid IPv6 address from NIC
        # Note fe80:: addresses need to be excluded 
        addr=`ifconfig $interface | awk '/inet6/ {if (substr($2, 1, 6) != "fe80::") {print $2; exit;}}'`
        #addr=''

        # Check if there's a valid address
        if [ x$addr = x ]; then
            echo "No valid IPv6 address assigned to $interface, will try in 30sec"
            sleep 30
        fi
    done

    # Compare with a last address
    if [ $lastaddr != $addr ]; then
        # Show current time
        date
        echo "$lastaddr -> $addr "

        # Send address update message to NO-IP and receive response
        res=$(/usr/local/bin/curl --get --silent --show-error --user-agent "$agent" --user "$user:$pass" -d "hostname=$hostname" -d "myipv6=$addr" $url)

        # There seem to be the following three responses
        # res="good"
        # res="nochg xxxx"
        # res="911"
        echo "Response: $res"

        # Check response
        # 911
        if [ "$res" = "911" ]; then
            echo "911 response, will try again"
            return
        fi

        # good: Address has been updated
        #echo $res | grep -q -E "^good*|^nochg*"
        echo $res | grep -q -E "^good"
        if [ $? -eq 0 ]; then
            lastaddr=$addr
            echo "Updated"
            return
        fi

        # nochg XXX: No change
        echo $res | grep -q -E "^nochg"
        if [ $? -eq 0 ]; then
            lastaddr=$addr # $lastaddr may be "none", need to be updated anyway
            echo "Not changed"
            return
        fi

        # Other response
        echo "Unkonwn response: $res"
    fi
}

# Update IPv6
while :
do
    UpdateIP
    sleep $interval
done
