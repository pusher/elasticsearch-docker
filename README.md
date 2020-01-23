# elasticsearch

## What is this

Elasticsearch docker images with a more modern JVM

## Why?

Because having control of the exact elasicsearch you use will make your infrastructure more stable.

## Usage

To see available *make* commands simply run `make`.. of note is:
* `make docker-build` to create docker images



# Origins


### Dockerfile.5.6

Most of the steps in the Dockerfile were reverse engineered from the upstream elasticsearch image. it was over 2 years old at the time of writing and I couldn't find a Dockerfile so I used `dive` and `docker inspect` to re-create it.




# TODO:
- dumb-init / tini
- maybe bake in the exporter (optional)
