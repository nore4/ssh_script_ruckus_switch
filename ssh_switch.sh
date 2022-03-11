#!/bin/bash
#
# A small bash script with an expect function. 
# Get lldp neighbours from a ruckus switch.
#
# ssh function with /usr/bin/expect
ssh_function () {
        read -p "Enter your username for <put_server_IP_here>: " NEM_USR
	read -sp "Enter your password for <server>: " PSWD
	echo ""
	read -p "Enter the IP-Address on the switch: " SW_IP
	read -p "Enter the username on the switch: " SW_USR
	read -sp "Enter your password on the switch: " SW_PWD
	echo ""
				
	/usr/bin/expect <<EOF
        set force_conservative 0
        spawn ssh $NEM_USR@<server_IP_here>
	expect "*password*"
	send -- "$PSWD\r"
	expect "*#"
	send "ssh $SW_USR@$SW_IP\r"
	expect "*password*"
	send -- "$SW_PWD\r"
	expect -- "*?2626#*"
        log_file -a my_log.log
        send -- "show lldp neighbors \r"
        expect -- "*?2626#*"
        log_file
        send -- "exit \r"
        expect -- "*?2626#*"
        send -- "exit \r"
        expect -- "*?2626#*"
EOF
}


docs_func () {
        sed 's/[[:space:]]\+/,/g' my_log.log > logging.csv
        ssconvert logging.csv logging.xlsx
}


# call the functions
ssh_function
docs_func
