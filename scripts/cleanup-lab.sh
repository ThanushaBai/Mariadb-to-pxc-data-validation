#!/bin/bash
# Stops and removes the lab containers.

echo "Stopping and removing containers..."
sudo docker stop source-mysql target-mysql
sudo docker rm source-mysql target-mysql
echo "Cleanup complete."