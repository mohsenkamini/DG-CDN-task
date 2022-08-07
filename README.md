# DG-CDN-task


### networking 

Subnet: `172.25.0.0/16`

- **Between client and ISP router**

  - range: `172.25.0.0/24`
  - network name: `client_side`

Hosts:

| Host | IP |
|---|---|
| ISP Router | 172.25.0.1 |
| Client | 172.25.0.2 |


- **Between the ISP router and Edge router**

  - range: `172.25.1.0/24`
  - network name: `bgp_side`

Hosts:

| Host | IP |
|---|---|
| ISP Router | 172.25.1.1 |
| Edge Server | 172.25.1.2 |



- **Between the Edge router, webserver, and logger**


  - range: `172.25.2.0/24`
  - network name: `server_side`

Hosts:

| Host | IP |
|---|---|
| Edge Server | 172.25.2.1 |
| nginx-reverse-proxy | 172.25.2.2 |
| elasticsearch(es01) | 172.25.2.3 |
| elasticsearch(es02) | 172.25.2.4 |
| kibana | 172.25.2.5 |
| prometheus-web-server | 172.25.2.6 |
| filebeat | 172.25.2.7 |


Other instances will receive their IP addresses from DHCP.


### Implementation


~~~
./network-create.sh

if [ `grep 'vm.max_map_count' /etc/sysctl.conf` ] ; then sed -i 's/^.*vm.max_map_count.*/vm.max_map_count = 262144/g' /etc/sysctl.conf && sysctl -p ; else echo "vm.max_map_count = 262144" | tee -a /etc/sysctl.conf && sysctl -p ; fi

~~~



### Passwords

kibana.yml
filebeat.yml
docker-compose.yml for kibana

