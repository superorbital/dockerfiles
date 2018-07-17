FROM debian:jessie as stress-builder

RUN apt-get update && apt-get install -yq make gcc

WORKDIR /code

# download stress-ng sources
ARG STRESS_VER
ENV STRESS_VER ${STRESS_VER:-0.08.17}
ADD https://github.com/ColinIanKing/stress-ng/archive/V${STRESS_VER}.tar.gz .
RUN tar -xf V${STRESS_VER}.tar.gz && mv stress-ng-${STRESS_VER} stress-ng
# make static version
WORKDIR /code/stress-ng
RUN STATIC=1 make

### Actual image ###

FROM alpine:3.6

COPY --from=stress-builder /code/stress-ng/stress-ng /bin

RUN apk add --no-cache bash 
RUN apk add --no-cache bind-tools
RUN apk add --no-cache curl
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache ethtool 
RUN apk add --no-cache iproute2 
RUN apk add --no-cache mysql-client
RUN apk add --no-cache net-tools 
RUN apk add --no-cache netcat-openbsd
RUN apk add --no-cache tcpdump 
RUN apk add --no-cache vim 

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

ADD https://dl.k8s.io/v1.11.0/kubernetes-client-linux-amd64.tar.gz .
RUN tar -zxf kubernetes*.tar.gz && mv kubernetes/client/bin/kubectl /usr/bin/kubectl && chmod +x /usr/bin/kubectl && rm -rf kubernetes

ADD https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip .
RUN unzip vault*.zip && mv vault /usr/bin/vault && chmod +x /usr/bin/vault && rm vault*.zip

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/bash", "-il"]

