#!/bin/bash

docker build -t truebad0ur/pgbench:v2 .
docker run --network host \
	-e POSTGRES_DB="app" \
	-e POSTGRES_USER="app" \
	-e POSTGRES_PASSWORD="app" \
	-e POSTGRES_URL="localhost" \
	-e ITERATIONS="1000000" \
	-e WORKERS="16" \
	truebad0ur/pgbench:v2
