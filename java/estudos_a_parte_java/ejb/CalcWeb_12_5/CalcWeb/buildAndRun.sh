#!/bin/sh
mvn clean package && docker build -t com.mycompany/CalcWeb .
docker rm -f CalcWeb || true && docker run -d -p 9080:9080 -p 9443:9443 --name CalcWeb com.mycompany/CalcWeb