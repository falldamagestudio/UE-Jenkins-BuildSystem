.PHONY: build run-development run-production

build:
	docker-compose build

run-development:
	docker-compose -f docker-compose.yml -f docker-compose.development.yml up

run-production:
	docker-compose -f docker-compose.yml -f docker-compose.production.yml up
