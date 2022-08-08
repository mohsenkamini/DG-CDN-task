#!/bin/bash
set -euxo pipefall 

wait_for_health () {
  
  local status=`docker inspect --format='{{json .State.Health.Status}}' $1`
  for i in {1..3}
  do
    if [ $status == "healthy" ]
    then
        echo $1 is healthy. moving on.
        i=3
    else
        echo $1 is not healthy something's wrong. we're giving it $2 more seconds.
        sleep $2
        ((i++))
        if [ $i -eq 3 ]
        then
            echo something is wrong. please check it manually. exiting ...
            exit 1
        fi
    fi
}

install_elk () {
  
  cd ./elk
  docker-compose -f create-certs.yml run --rm create_certs
  docker-compose -f secure-docker-compose.yml up -d
  sleep 45
  
  docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords auto --batch --url https://es01:9200" > passwords
  echo "Your passwords are stored in passwords file"
  sed -i "s|KIBANA_ELASTICSEARCH_PASSWORD=.*|KIBANA_ELASTICSEARCH_PASSWORD=`grep "PASSWORD kibana_system" passwords| awk '{print $4}'`|g" .env
  
}


