

.PHONY: build run

build:
	docker build -t j --progress plain .

run: 
	docker run --rm -p 8080:8080 --name jenkins -it --env JENKINS_ADMIN_USERNAME=admin --env JENKINS_ADMIN_PASSWORD=smurf j

