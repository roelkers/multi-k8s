docker build -t roelkers/multi-client:latest -t roelkers/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t roelkers/multi-worker:latest -t roelkers/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker build -t roelkers/multi-server:latest -t roelkers/multi-server:$SHA -f ./server/Dockerfile ./server
echo 1
docker push roelkers/multi-client:latest
docker push roelkers/multi-worker:latest
docker push roelkers/multi-server:latest
echo 2
docker push roelkers/multi-client:$SHA
docker push roelkers/multi-worker:$SHA
docker push roelkers/multi-server:$SHA
echo 3
kubectl apply -f k8s
echo 4
kubectl set image deployments/server-deployment server=roelkers/multi-server:$SHA
kubectl set image deployments/client-deployment client=roelkers/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=roelkers/multi-worker:$SHA
