#!/usr/bin/env bash

# Loads sample data from
# https://www.elastic.co/guide/en/kibana/current/tutorial-load-dataset.html

USERNAME=elastic
PASSWORD=changeme

wget https://download.elastic.co/demos/kibana/gettingstarted/shakespeare.json
wget https://download.elastic.co/demos/kibana/gettingstarted/accounts.zip
wget https://download.elastic.co/demos/kibana/gettingstarted/logs.jsonl.gz

unzip accounts.zip
rm accounts.zip
gunzip logs.jsonl.gz

curl -H 'Content-Type: application/json' -u ${USERNAME}:${PASSWORD} -XPUT http://localhost:9200/shakespeare -d '
{
 "mappings" : {
  "_default_" : {
   "properties" : {
    "speaker" : {"type": "string", "index" : "not_analyzed" },
    "play_name" : {"type": "string", "index" : "not_analyzed" },
    "line_id" : { "type" : "integer" },
    "speech_number" : { "type" : "integer" }
   }
  }
 }
}
';

curl -H 'Content-Type: application/json' -u ${USERNAME}:${PASSWORD} -XPUT http://localhost:9200/logstash-2015.05.18 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -H 'Content-Type: application/json' -u ${USERNAME}:${PASSWORD} -XPUT http://localhost:9200/logstash-2015.05.19 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -H 'Content-Type: application/json' -u ${USERNAME}:${PASSWORD} -XPUT http://localhost:9200/logstash-2015.05.20 -d '
{
  "mappings": {
    "log": {
      "properties": {
        "geo": {
          "properties": {
            "coordinates": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
';

curl -H 'Content-Type: application/x-ndjson' -u ${USERNAME}:${PASSWORD} -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @accounts.json
curl -H 'Content-Type: application/x-ndjson' -u ${USERNAME}:${PASSWORD} -XPOST 'localhost:9200/shakespeare/_bulk?pretty' --data-binary @shakespeare.json
curl -H 'Content-Type: application/x-ndjson' -u ${USERNAME}:${PASSWORD} -XPOST 'localhost:9200/_bulk?pretty' --data-binary @logs.jsonl

rm accounts.json
rm shakespeare.json
rm logs.jsonl

curl -u ${USERNAME}:${PASSWORD} 'localhost:9200/_cat/indices?v'
