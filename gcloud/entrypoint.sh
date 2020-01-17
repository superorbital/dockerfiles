#!/bin/bash
set -e

main() {
  ls -las /
  [[ -f /sa.json ]] || usage "Must mount service account credentials into /sa.json"

  gcloud auth activate-service-account --key-file=/sa.json

  exec "$@"
}

usage() {
  echo
  echo "Error: $*"
  echo
  cat /README.md
  echo
  exit 1
}

main "$@"
