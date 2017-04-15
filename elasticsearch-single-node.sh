#!/usr/bin/env bash

IMAGE=docker.elastic.co/elasticsearch/elasticsearch
VERSION=5.3.0

docker run -d -p 9200:9200 -p 9300:9300 --name docker-elasticsearch \
 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" \
 -e "cluster.name=elasticsearch-docker" -e "node.name=elasticsearch-docker" \
 -e "bootstrap.memory_lock=true" \
 ${IMAGE}:${VERSION}
