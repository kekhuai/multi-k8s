#!/bin/bash
docker image build -t kekhuay/multi-client:latest -t kekhuay/multi-client:$SHA -f ./client/Dockerfile ./client
docker image build -t kekhuay/multi-server:latest -t kekhuay/multi-server:$SHA -f ./server/Dockerfile ./server
docker image build -t kekhuay/multi-worker:latest -t kekhuay/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push kekhuay/multi-client:latest
docker push kekhuay/multi-server:latest
docker push kekhuay/multi-worker:latest

docker push kekhuay/multi-client:$SHA
docker push kekhuay/multi-server:$SHA
docker push kekhuay/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=kekhuay/multi-server:$SHA
kubectl set image deployments/client-deployment client=kekhuay/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kekhuay/multi-worker:$SHA
