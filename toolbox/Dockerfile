FROM library/python:3.6

RUN apt-get update && apt-get -y install iproute2 net-tools ethtool vim tcpdump

CMD ["/usr/bin/python", "-m", "SimpleHTTPServer", "5000"]

