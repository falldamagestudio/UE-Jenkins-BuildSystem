.PHONY: build run-development

build:
	docker-compose build

run-development:
	docker-compose -f docker-compose.yml -f docker-compose.development.yml up
