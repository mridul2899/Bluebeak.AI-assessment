#!/bin/bash

container_id=$(sudo docker ps -aqf "name=mridul-assessment")
container_ip=$(sudo docker inspect $container_id | grep -w "IPAddress" | awk 'NR==1 {print $2}' | awk -F'"' '{print $2}')

for x in {1..100};
   do (curl -s -w 'Total: %{time_total}s\n' "$container_ip:8080/up?project=../test/prj-1&data=../test/newt.csv&name=n_${x}&description=batchtest" &);
done