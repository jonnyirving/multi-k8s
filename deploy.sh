
# Build docker images and tag with both latest and GIT SHA
docker build -t jonnyi/multi-client:latest -t jonnyi/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jonnyi/multi-server:latest -t jonnyi/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jonnyi/multi-worker:latest -t jonnyi/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images tagged with latest to docker hub
docker push jonnyi/multi-client:latest
docker push jonnyi/multi-server:latest
docker push jonnyi/multi-worker:latest

# Push images tagged with git SHA to docker hub
docker push jonnyi/multi-client:$SHA
docker push jonnyi/multi-server:$SHA
docker push jonnyi/multi-worker:$SHA

# Apply k8s config
kubectl apply -f k8s

# Use imperitive commands to update deployment image versions
kubectl set image deployments/client-deployment client=jonnyi/multi-client:$SHA
kubectl set image deployments/server-deployment server=jonnyi/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=jonnyi/multi-worker:$SHA
