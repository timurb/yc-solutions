#!/bin/sh

# Authenticate to docker registry
#
# For production use see README.md

cat docker-push.json \
| docker login --username json_key \
               --password-stdin \
               cr.yandex
