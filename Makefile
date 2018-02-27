default: build push

build:
	docker build -t enspirit/sbt-builder .

push:
	docker push enspirit/sbt-builder
