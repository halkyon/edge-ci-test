# Storj Edge CI

This is the source to build a Docker container suitable for running and testing
Storj edge services.

It's designed to be a superset of [storj/ci](https://github.com/storj/ci/).

It contains:

* Everything in storj/ci: linters, tools, and packages for CI environments
* [gateway-mint](https://github.com/storj/gateway-mint)
* [splunk-s3-tests](https://github.com/storj/splunk-s3-tests)

## TODO

* Bring in integration test scripts from Gateway-ST
* Install [rclone and test command](https://github.com/storj/gateway-st/blob/main/testsuite/integration/rclone.sh)
* CI: when a change to this repo is made, it should test it against latest Gateway-ST and MT

## Building

* Check out this code somewhere
* Run `git submodule update --init`
* Run `make build-image`

You now have a Docker image `storjlabs/edge-ci:latest` available to use.

## Running integration tests

minio/mint tests are installed into `/mint`.
To run them: `cd /mint && ./entrypoint.sh`.

splunk-s3-tests are installed into `/s3-tests`.
To run them: `cd /s3-tests && nosetests -a '!skip_for_splunk,!skip_for_storj'`.

### Gateway-ST

This assumes you have [Gateway-ST](https://github.com/storj/gateway-st) code
checked out somewhere:

```
cd /path/to/gateway

docker run \
	-v $PWD:/gateway \
	-v $(go env GOMODCACHE):/tmp/go-mod \
	-e GOMODCACHE=/tmp/go-mod \
	-e STORJ_SIM_POSTGRES='postgres://postgres@localhost/integration?sslmode=disable' \
	storjlabs/edge-ci /bin/bash -c 'service postgresql start \
		&& psql -U postgres -c "create database integration" \
		&& /gateway/testsuite/integration/run.sh'
```

TODO: The test scripts are currently hosted in Gateway-ST, but ultimately should
reside in the edge-ci container.

Note: `GOMODCACHE` volume and environment variable aren't strictly required, but
help to speed things up by using your local Go cache instead of downloading
modules from scratch.

## Gateway-MT

TODO
