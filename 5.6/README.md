inspured by elasticsearch:5.6


```
docker run --rm --entrypoint /bin/sh elasticsearch:5.6 -c "cat /docker-entrypoint.sh" > /docker-entrypoint.sh
docker run --rm --entrypoint /bin/sh elasticsearch:5.6 -c "cat /usr/share/elasticsearch/config/docker-entrypoint.sh" > elasticsearch.yml
docker run --rm --entrypoint /bin/sh elasticsearch:5.6 -c "cat /usr/share/elasticsearch/config/log4j2.properties" > log4j2.properties
```

TODO: tini/dumb-init maybe
