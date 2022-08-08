#!/bin/bash
set -euo pipefail

echo "This script will test everything in the Digikala Infrastructure -CDNTask Assignment document and makes sure everything is working.
"

echo "==========================================================

"

check_networks () {
	echo "==========================================================
"
	echo -n "checking networks: "

	echo "
created docker networks:
"
	docker network ls  | grep "bgp_side\|client_side\|server_side"
	sleep 2
	echo "
network ranges:
"
	for i in `docker network ls  | grep "bgp_side\|client_side\|server_side" | awk '{print $1}'` 
	do
		docker network inspect --format='{{.Name}}' $i
	echo "
Subnet          IPRange       Gateway"
	docker network inspect --format='{{.IPAM.Config}}' $i
	sleep 2
	echo "
Containers:"
	docker network inspect --format='{{.Containers}}' $i | sed 's/:{/  /g' | sed 's|/24|/24\n|g' | sed 's/map.*  /dum dum /g' | awk '{print $3,$6}'
	echo ""
	sleep 3
	done
}


check_web_server_from_client () {
echo "==========================================================
"

	echo "STEP 1: 
	Web server review
&

STEP 3:
	from client point of view
	
	"
	set -x 
	docker exec -it client /bin/sh -c 'curl http://172.25.2.2:80/graph'
	set +x 
}


test_bgp_routes () {
	
echo "
==========================================================
"
	echo "STEP 2:
	Traceroute from client: 172.25.0.2 to nginx_reverse_proxy: 172.25.2.2
	
	"
	set -x 
	docker exec -it client /bin/sh -c 'mtr -r 172.25.2.2'
	set +x 

	echo "
output of birdc show route isp-router:
	"
	set -x 
	docker exec -it isp-router birdc show route
	set +x 
	echo "
output of birdc show route edge-server:
	"
	set -x 
	docker exec -it edge-server birdc show route
	set +x 
}

http_flood_test () {

echo "
==========================================================
"

	echo "STEP 5:
	Checking rate limit ... + heavy load script using pyflooder.py
	"
	set -x 
	docker exec -it client python3 pyflooder.py 172.25.2.2 80 1000
	set +x 

	echo "
	CHECK ELK logs. there are links in the README.md for that.
	"
	echo "
	Checking Headers: (for a cache content to be a \"HIT\" there should be 3 requests as configured)
	look out for headers: Server,X-Cache-Status,X-Time
       	
	"
	set -x
	for i in {1..3} ; do docker exec -it client /bin/sh -c ' curl -i http://172.25.2.2/graph' ; done
	set +x 



}

cache_purge () {

echo "
==========================================================
"
	echo "deleting graph from cache if exist. to try other files go back to README
	"
	set -x
	docker exec -it nginx_reverse_proxy sh -c '/cache_purger.sh graph /cache '
	set +x 
}





check_networks
check_web_server_from_client
test_bgp_routes
http_flood_test
cache_purge
