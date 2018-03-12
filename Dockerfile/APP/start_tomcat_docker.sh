#!/bin/bash
docker build . -t app_container
docker run -d -p 8081:8080 app_container
