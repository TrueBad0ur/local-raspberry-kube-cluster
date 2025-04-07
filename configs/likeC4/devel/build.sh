#!/bin/bash

docker build -t likec4 . && docker run --rm -p 8080:80 likec4:latest
open -a "Firefox Developer Edition" 'http://localhost:8080'
