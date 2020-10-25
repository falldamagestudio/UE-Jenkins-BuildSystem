

.PHONY: build run

build:
	docker-compose build

start:
	docker-compose up

stop:
	docker-compose down -v