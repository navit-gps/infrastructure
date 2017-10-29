#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json

print('Loading function')


def lambda_handler(event, context):

    print(event)

    return {"statusCode": 200, \
        "headers": {"Content-Type": "application/json"}, \
        "body": "{\"version_name\": \"live\"" + \
        ", \"version_code\": \"live\"}"}
