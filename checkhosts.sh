#!/usr/bin/env bash
cat /etc/hosts | while read ip name rest
do
	if [ -z "$ip" ] || [[ "$ip" == "#"* ]]
	then
		continue
	fi
	
	result=$(nslookup "$name" | awk '/^Name:/ {found=1; next} found && /^Address: / {print $2}')
	found=0
	for dnsip in $result
	do
		if [ "$dnsip" = "$ip" ]
		then
			found=1
		fi
	done
	if [ "$found" -eq 0 ]
	then
		echo "Bogus IP for $name in /etc/hosts!"
	fi
done
