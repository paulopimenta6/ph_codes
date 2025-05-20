@echo off
call mvn clean package
call docker build -t com.mycompany/CalcWeb .
call docker rm -f CalcWeb
call docker run -d -p 9080:9080 -p 9443:9443 --name CalcWeb com.mycompany/CalcWeb