FROM elasticsearch:7.14.0
ENTRYPOINT ip route del default && ip route add default via 172.25.2.1 && /bin/tini -- /usr/local/bin/docker-entrypoint.sh eswrapper
