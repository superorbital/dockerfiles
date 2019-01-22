#!/usr/bin/env python

from flask import Flask, request, jsonify
import json
webhook = Flask(__name__)

@webhook.route('/', methods=['POST'])
def webhook_endpoint():
  allowed = True
  req    = request.json["request"]
  uid    = req["uid"]
  object = req["object"]
  labels = object["metadata"]["labels"]
  env    = labels["environment"]
  # Pods must have `env:foo` label
  if not env:
    allowed = False

  return jsonify({
    "response": {
      "uid": uid,
      "allowed": allowed
    }
  })

webhook.run(host='0.0.0.0', port=80, debug=True)
