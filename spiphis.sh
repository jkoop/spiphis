#! /bin/bash
a=$(ip a | grep -o 'inet [0-9]*\.[0-9]*\.[0-9]*' | tail -n 1 | sed 's/inet //g')
p(){ echo -en "> $1        \r"; if [ "$(ping -c 1 $1 &> /dev/stdout | grep -o nrea)" != "nrea" ]; then
  for q in 20 21 22 23 80 88 443 2200 2222 3389 5900 8000 8080 8303 10000; do
    echo -en "> $1:$q        \r"; s $1 $q &
  done
fi }
s(){ if [ "$(nc -vnz $1 $2 &> /dev/stdout | head -c 1)" == "C" ]; then echo -e "\e[92mSuccess\e[0m  $1:$2"; fi }
if [ $a == '127.0.0' ]; then echo "No network connection. Not scanning"; exit 1; fi
echo -e "IP ADDR  $a/24\n    TCP  20 21 22 23 80 88 443 2200 2222 3389 5900 8000 8080 8303 10000"
for b in {1..254}; do p $a.$b & done
wait
