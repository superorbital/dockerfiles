Docker image that wraps [GoogleCloudPlatform/cloud-sdk-docker](https://github.com/GoogleCloudPlatform/cloud-sdk-docker) to make authentication easier

Forked from [messari/docker-google-cloud-sdk-auth-wrapper](https://github.com/messari/docker-google-cloud-sdk-auth-wrapper)

#### Usage

Mount your service account jon file into the container as `/sa.json`:

``` bash
docker run \
  --mount "type=bind,source=$(pwd)/fake_sa.json,target=/sa.json" \
  superorbital/gcloud \
  gcloud compute instances list --project my-project
```

The `WORKDIR` is set to `/work`, so any uploads or downloads should happen via
host volume mounts against that directory:

``` bash
docker run \
  --mount "type=bind,source=$(pwd)/fake_sa.json,target=/sa.json" \
  --mount "type=bind,source=$(pwd)/,target=/work" \
  superorbital/gcloud \
  gsutil cp gs://bucket/* .
```
