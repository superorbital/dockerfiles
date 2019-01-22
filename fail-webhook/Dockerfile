FROM python:3.7
RUN pip3 install pipenv
WORKDIR /app
COPY . .
RUN set -ex && pipenv install --deploy --system
ENTRYPOINT ["python"]
CMD [ "webhook.py" ]
