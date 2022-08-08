# DG-CDN-task

## Setup

### Requirements
- The initial setup requires your environment to already have docker engine installed. [install docker for ubuntu](https://docs.docker.com/engine/install/ubuntu/)

- Since this is a lab project, Please set this up with `root` access so you wouldn't face unexpected problems.

- The most resource-greedy part of this project is the `ELK` stack. although for being more resource-frindly we're installing an older version of `7.14.0`. But it is still greedy! so it is recommended to have at least 4GB of RAM on your machine.

- **Make sure** you have a **secure VPN connection** since `ELK` has buckled up on all those sanctions. It is also recommended to have run `docker login` so you wouldn't face any issue during the image pulling process.


### Initial Setup

There's a script which will do all the setup work for you.
You just need to run the following commands with `root`:

~~~
cd /root/
git clone git@github.com:mohsenkamini/DG-CDN-task.git
cd ./DG-CDN-task/
./setup.sh
~~~

- This script basically:

  - Installs `docker-compsoe` utility 
  - Creates docker networks
  - pulls docker images
  - Runs docker containers and configure them if needed

### Put it to test


### Clean up

You can clean up your system with the `clean_up.sh` script. although you should notice that this will erase all your docker volumes, containers and images.


# Details

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
| Edge Server | 172.25.1.1 |
| ISP Router | 172.25.1.2 |



- **Between the Edge router, webserver, and logger**


  - range: `172.25.2.0/24`
  - network name: `server_side`

Hosts:

| Host | IP |
|---|---|
| Edge Server | 172.25.2.1 |
| nginx-reverse-proxy | 172.25.2.2 |
| es01(elasticsearch) | 172.25.2.3 |
| es02(elasticsearch) | 172.25.2.4 |
| kib01 (kibana) | 172.25.2.5 |
| prometheus | 172.25.2.6 |
| fb01 | 172.25.2.7 |
| fb02 | 172.25.2.8 |


### test rate limit

~~~
docker exec -it client python3 pyflooder.py 172.25.2.2 80 1000
~~~

### cache purge

e.g:
~~~
docker exec -it nginx_reverse_proxy sh -c '/cache_purger.sh main.ec237bfc.css /cache '
~~~


### Know Issues


~~~
Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist

~~~
