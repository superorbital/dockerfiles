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
RUN apk add --no-cache ethtool 
RUN apk add --no-cache iproute2 
RUN apk add --no-cache mysql-client
RUN apk add --no-cache net-tools 
RUN apk add --no-cache netcat-openbsd
RUN apk add --no-cache tcpdump 
RUN apk add --no-cache vim 

CMD ["/bin/bash", "-il"]

