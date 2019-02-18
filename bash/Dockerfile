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

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /tini
ADD https://dl.k8s.io/v1.11.0/kubernetes-client-linux-amd64.tar.gz .
ADD https://releases.hashicorp.com/vault/0.10.3/vault_0.10.3_linux_amd64.zip .

RUN apk add --no-cache bash            \
                       bind-tools      \
                       curl            \
                       ca-certificates \
                       ethtool         \
                       iproute2        \
                       mysql-client    \
                       net-tools       \
                       netcat-openbsd  \
                       tcpdump         \
                       vim             \
                       python3         \
                       jq              \
  && chmod +x /tini \
  && tar -zxf kubernetes*.tar.gz \
  && mv kubernetes/client/bin/kubectl /usr/bin/kubectl \
  && chmod +x /usr/bin/kubectl \
  && rm -rf kubernetes* \
  && unzip vault*.zip \
  && mv vault /usr/bin/vault \
  && chmod +x /usr/bin/vault \
  && rm vault*.zip \
  && pip3 install --upgrade pip setuptools httpie \
  && rm -r /root/.cache

ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash", "-il"]

