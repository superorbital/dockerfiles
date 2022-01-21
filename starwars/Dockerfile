FROM python:3

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini-static /tini
RUN chmod +x /tini

ADD server.py /server.py
ADD starwars.ascii /starwars.ascii

ENTRYPOINT ["/tini", "--"]
CMD ["python3", "server.py"]
