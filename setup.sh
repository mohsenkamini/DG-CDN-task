#!/bin/bash
set -euxo pipefail 
source .setup-lib.sh


## MAIN SECTION
install_docker_compose
create_networks
set_vm_map_count
install_prometheus
install_nginx_reverse_proxy
#install_elk
install_bgp_client
