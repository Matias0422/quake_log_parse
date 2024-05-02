DOCKER_IMAGE_NAME := quake-log-parser
ENV_LOCAL_FILE := .env.local
ENV_TEST_FILE := .env.test

setup:
	sudo docker build -t ${DOCKER_IMAGE_NAME} .

run-local:
	sudo docker run --rm --env-file ${ENV_LOCAL_FILE} ${DOCKER_IMAGE_NAME}

run-test:
	sudo docker run --rm --env-file ${ENV_TEST_FILE} ${DOCKER_IMAGE_NAME} rspec

clean:
	sudo docker stop $$(docker ps -q --filter ancestor=${DOCKER_IMAGE_NAME})
	sudo docker rmi ${DOCKER_IMAGE_NAME}
