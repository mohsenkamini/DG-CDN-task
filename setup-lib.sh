#!/bin/bash
#set -euxo pipefail 



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
  echo "Your passwords are stored in passwords file"
  sed -i "s|KIBANA_ELASTICSEARCH_PASSWORD=.*|KIBANA_ELASTICSEARCH_PASSWORD=`grep "PASSWORD kibana_system" passwords| awk '{print $4}'`|g" .env
  docker-compose -f secure-docker-compose.yml up -d
  docker-compose -f secure-docker-compose.yml down
  
}


