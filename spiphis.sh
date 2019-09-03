#! /bin/bash

##  File originated from https://joekoop.com/spiphis/download/spiphis_v0.1.0.sh.xz
##  Spiphis MIT license 2019 Joe Koop
##  Read the documentation at https://joekoop.com/spiphis/docs/v0.1.0/

if [ "$(nc -v 2> >(grep -o 'command not found'))" == "command not found" ]; then
	echo "netcat not installed. Install with"
	echo "sudo apt install netcat"
	exit 1
fi

if [ "$1" != "-script" ]; then
	echo "Use '-script' as first argument to not print progress text"
	echo "Read the documentation at https://joekoop.com/posom/docs/v0.1.0/"
fi

if [ "$1 " != ' ' ] && [ "$1" != "-script" ]; then
	exit 1
fi

function scan(){
	if [ "$(nc -vnzw 2 $1 $2 &> /dev/stdout | head -c 1)" == "C" ]; then
		echo -e '\e[92mSuccess\e[0m  '$1:$2
	fi
}

g="10.0"  # x.x._._:_

for h in {0..0}; do  # _._.x._:_
	for i in {1..255}; do  # _._._.x:_
		for j in 20 21 22 23 80 88 443 2200 2222 3389 5900 8000 8080 10000; do  # _._._._:x
			if [ "$1" != "-script" ]; then
				echo -en "> $g.$h.$i:$j        \r"
			fi
			scan $g.$h.$i $j &
		done
	done
done

sleep 2  # sleep to wait for last netcat to timeout
exit 0
