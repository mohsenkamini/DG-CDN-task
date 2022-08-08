FROM nginx:1.23.1-alpine
RUN apk update
RUN apk add --upgrade iproute2 mtr
ENTRYPOINT ip route del default && ip route add default via 172.25.2.1 && nginx -g "daemon off;"
