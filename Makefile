.PHONY build:
build:
	docker buildx build --tag ubuntu-supervisor .


.PHONY run:
run:
	docker run --publish 20080:80 --publish 28080:8080 --rm --name ubuntu-supervisor ubuntu-supervisor
