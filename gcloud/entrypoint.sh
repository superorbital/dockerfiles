#!/bin/bash
set -e

main() {
  [[ -f /sa.json ]] || usage "Must mount service account credentials into /sa.json"

  gcloud auth activate-service-account --key-file=/sa.json --quiet 2>&1 | grep -v "Activating"

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
