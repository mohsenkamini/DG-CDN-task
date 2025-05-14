#!/bin/bash
#set -euxo pipefail 

install_docker_compose () {

	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	docker-compose --version
}

create_networks () {

docker network create \
  --driver=bridge \
  --subnet=172.25.0.0/24 \
  --ip-range=172.25.0.0/24 \
  --gateway=172.25.0.254 \
  client_side || true

docker network create \
  --driver=bridge \
  --subnet=172.25.1.0/24 \
  --ip-range=172.25.1.0/24 \
  --gateway=172.25.1.254 \
  #bgp_side || true
  t-c-network || true

docker network create \
  --driver=bridge \
  --subnet=172.25.2.0/24 \
  --ip-range=172.25.2.0/24 \
  --gateway=172.25.2.254 \
  server_side || true

docker network create \
  --driver=bridge \
  --subnet=172.25.3.0/24 \
  --ip-range=172.25.3.0/24 \
  --gateway=172.25.3.254 \
  #bgp_side || true
  t-u-network || true



}

set_vm_map_count () {

	if [ `grep 'vm.max_map_count' /etc/sysctl.conf` ] ; then sed -i 's/^.*vm.max_map_count.*/vm.max_map_count = 262144/g' /etc/sysctl.conf && sysctl -p ; else echo "vm.max_map_count = 262144" | tee -a /etc/sysctl.conf && sysctl -p ; fi 

}



install_prometheus () {

	cd ./web-server/
	docker-compose pull
	docker-compose up -d 
	cd - 
}

install_nginx_reverse_proxy () {

	cd reverse_proxy 
	docker-compose pull 
	docker-compose build 
	docker-compose up -d 
	cd -
}

install_elk () {
  
	cd ./elk
	docker-compose -f create-certs.yml run --rm create_certs
	docker-compose -f secure-docker-compose.yml up -d
	sleep 45 
	docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url https://es01:9200" > passwords
	echo "Your passwords are stored in \"./passwords\" file"
	sed -i "s|KIBANA_ELASTICSEARCH_PASSWORD=.*|KIBANA_ELASTICSEARCH_PASSWORD=`grep "PASSWORD kibana_system" passwords| awk '{print $4}'`|g" .env
	sed  -i "s|  password:.*|  password: `grep "PASSWORD elastic" passwords| awk '{print $4}'`|g" ./data/filebeat/filebeat.docker*.yml
	cp /var/lib/docker/volumes/dg_certs/_data/ca/ca.crt ./ca.crt
	docker-compose -f secure-docker-compose.yml build
	docker-compose -f secure-docker-compose.yml up -d
	cd -
  
}

install_bgp_client () {

	cd BGP
	docker-compose build 
	docker-compose up -d 
	cd -
}
