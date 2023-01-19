#!/bin/bash

REPONAME="pasiechnyk/flask-hello"

LOCAL_DIGEST=$(sudo docker inspect --format='{{index .RepoDigests 0}}' pasiechnyk/flask-hello:latest | sed -r 's/^[^@]+//' | cut -c2-)
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${DOCKER_UNAME}'", "password": "'${DOCKER_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
HUB_DIGEST=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${REPONAME}/tags/?page_size=100 | jq -r '.results|.[]|.digest')


if [[ "$LOCAL_DIGEST" == "$HUB_DIGEST" ]]; then
 
else
    sudo docker pull pasiechnyk/flask-hello:latest
    sudo docker stop flask-hello
    sudo docker run -d --rm --name flask-hello -p 80:81 pasiechnyk/flask-hello
fi
