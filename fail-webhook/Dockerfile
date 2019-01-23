FROM python:3.7
RUN pip3 install pipenv
WORKDIR /app
COPY . .
RUN set -ex && pipenv install --deploy --system
ENTRYPOINT ["python"]
ENV FLASK_APP=webhook.py
CMD [ "-m", "flask", "run", "--host=0.0.0.0", "--port=80" ]
