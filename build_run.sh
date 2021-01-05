#!/bin/bash

sudo docker build -t bluebeakai-assessment .
echo -e "\nDocker container built successfully...\nNow running the docker container...\n"
sudo docker run --rm --name mridul-assessment -p 8080:8080 -it bluebeakai-assessment
