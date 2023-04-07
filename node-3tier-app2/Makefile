ECR_REPO=xxx
RELEASE=latest

# Docker build images:
release-webserver:
	#webserver
	docker build -f web/Dockerfile . -t test_web:latest --build-arg COMMIT=$(shell git rev-parse HEAD | cut -c1-7) && \
    docker tag test_web:latest ${ECR_REPO}/testapp_web:${RELEASE} && \
    docker push ${ECR_REPO}/testapp_web:${RELEASE}

release-api:
	#api
	docker build -f api/Dockerfile . -t test_api:latest --build-arg COMMIT=$(shell git rev-parse HEAD | cut -c1-7) && \
    docker tag test_api:latest ${ECR_REPO}/testapp_api:${RELEASE} && \
    docker push ${ECR_REPO}/testapp_api:${RELEASE}

release: release-api release-webserver
	echo "release $$RELEASE"
