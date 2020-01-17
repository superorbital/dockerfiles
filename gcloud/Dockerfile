FROM google/cloud-sdk:276.0.0-slim

COPY gcloud /root/.config/gcloud

WORKDIR /
COPY entrypoint.sh .
COPY README.md .

WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
