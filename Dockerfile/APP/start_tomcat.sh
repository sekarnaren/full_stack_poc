#!/bin/bash
cd /app/spring-framework-petclinic
nohup ./mvnw tomcat7:run-war -P PostgreSQL -Dmaven.test.skip=true &",
