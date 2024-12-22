#!/bin/bash

cd ..

docker build -t likec4 -f devel/Dockerfile . && docker run --rm -p 8080:80 likec4:latest &
open -a "Firefox Developer Edition" 'http://localhost:8080'
