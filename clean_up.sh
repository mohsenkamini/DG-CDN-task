#!/bin/bash
set -euxo pipefail

confirmate () {
  case $1 in
    -y)
      ans=y
      ;;
     *)
       read -r -p "This will delete all your docker containers,images and volumes. Are you SURE you want to do this?[y/n] " "ans"
       ;;
  esac
}


clean_up () {

  for i in `docker ps -q ` ; do docker stop $i ; docker rm $i ; done
  docker system prune -f --volumes
  for a in $(docker image ls | grep "$1" | awk {'print $3'}); do docker image rm -f $a; done
  
}

confirmate $1

case $ans in
  y)
    clean_up
    ;;
  n)
    echo "you did not confirm for a clean up. exiting..."
    exit 1
    ;;
  *)
    echo "only y or n is acceptable"
    exit 1
    ;;
esac

