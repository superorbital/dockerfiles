#!/usr/bin/env python

from flask import Flask, request, jsonify
import json
from pprint import pprint
webhook = Flask(__name__)

@webhook.route('/', methods=['POST'])
def webhook_endpoint():
  json_body = request.get_json()
  pprint(json_body)
  uid = json_body["request"]["uid"]

  return jsonify({
    "response": {
      "uid": uid,
      "allowed": True,
      "status": {
          "status": "Failure",
          "message": "whatever",
          "reason": "whatever",
          "code": 402
      }
    }
  })
