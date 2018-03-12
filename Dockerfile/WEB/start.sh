#!/bin/bash
cd /app/web_server
docker build . -t web_server_container
docker run -d -p 80:80 web_server_container
