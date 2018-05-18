FROM library/python:3.6-alpine

RUN apk add --no-cache bash 
RUN apk add --no-cache bind-tools
RUN apk add --no-cache curl
RUN apk add --no-cache ethtool 
RUN apk add --no-cache iproute2 
RUN apk add --no-cache mysql-client
RUN apk add --no-cache net-tools 
RUN apk add --no-cache netcat-openbsd
RUN apk add --no-cache tcpdump 
RUN apk add --no-cache vim 

CMD ["/bin/bash", "-il"]

