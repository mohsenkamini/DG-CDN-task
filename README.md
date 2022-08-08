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

To test the functionality of the stack you can make use of `test.sh` script. This script runs tests against the stack and brings you back information and tells you what part of the document it's testing.
- quick overview of `test.sh`:
  - check networks 
  - check web server from client **(STEP 1 & 3)**
  - test_bgp_routes **(STEP 2)**
  - http_flood_test  **(STEP 5)**

- You need to check ELK stack and its results from the GUI.**(STEP 4)**
`Kibana` is accessible from [https://localhost:5601](https://localhost:5601)
for the login credentials you can run:
~~~
grep "elastic" /root/DG-CDN-task/elk/passwords  | awk '{print $4,$5}'
~~~


access the web server through nginx: [http://localhost](http://localhost)
![image](https://user-images.githubusercontent.com/77579794/183503350-945c9198-840d-45d9-bffb-bd56d20d0688.png)



[Filebeat Nginx] Overview ECS: [https://localhost:5601/app/dashboards#/view/55a9e6e0-a29e-11e7-928f-5dbe6f6f5519-ecs?_g=(filters:!(),refreshInterval:(pause:!t,value:10000),time:(from:now-15m,to:now))](https://localhost:5601/app/dashboards#/view/55a9e6e0-a29e-11e7-928f-5dbe6f6f5519-ecs?_g=(filters:!(),refreshInterval:(pause:!t,value:10000),time:(from:now-15m,to:now)))

![image](https://user-images.githubusercontent.com/77579794/183501571-ef856e77-5192-4e19-99cd-18163db5e769.png)


[Filebeat Nginx] Access and error logs ECS: [https://localhost:5601/app/dashboards#/view/046212a0-a2a1-11e7-928f-5dbe6f6f5519-ecs?_g=(filters:!(),refreshInterval:(pause:!t,value:10000),time:(from:now-15m,to:now))](https://localhost:5601/app/dashboards#/view/046212a0-a2a1-11e7-928f-5dbe6f6f5519-ecs?_g=(filters:!(),refreshInterval:(pause:!t,value:10000),time:(from:now-15m,to:now)))

![image](https://user-images.githubusercontent.com/77579794/183501659-766a6585-2793-4e09-81d0-5048779c39e5.png)




Elastic different indicec: [https://localhost:5601/app/management/data/index_management/indices](https://localhost:5601/app/management/data/index_management/indices)

![image](https://user-images.githubusercontent.com/77579794/183501454-3a9fb944-3e6c-4f0d-9da8-3be9e28ca33f.png)


- **STEP 5:** On ELK side, create a retention mechanism to delete logs after X days/hours.

`This should've been an automated process using API but I'm out of time :)` so
click on the delete button
![image](https://user-images.githubusercontent.com/77579794/183516557-f7f9d156-c199-4aa1-8ebe-a073c607f4a9.png)

scroll down and set delete policy of your choice
![image](https://user-images.githubusercontent.com/77579794/183516812-40e332d3-70e1-4427-9f3f-00a9440daa51.png)


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

- If you encounter the following error, you could just ignore it.
~~~
Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist
~~~

- If encountered a connection error while pulling images or installing packages, Please consider checking your conncetion or trying a different `VPN` and just run the `setup.sh` script again.
