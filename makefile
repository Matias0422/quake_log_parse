DOCKER_IMAGE_NAME := quake-log-parser
ENV_LOCAL_FILE := .env.local
ENV_TEST_FILE := .env.test

setup:
	docker build -t ${DOCKER_IMAGE_NAME} .

run-local:
	docker run --rm --env-file ${ENV_LOCAL_FILE} ${DOCKER_IMAGE_NAME}

run-test:
	docker run --rm --env-file ${ENV_TEST_FILE} ${DOCKER_IMAGE_NAME} rspec

clean:
	docker rmi ${DOCKER_IMAGE_NAME}
