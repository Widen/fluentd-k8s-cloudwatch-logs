all: push
.phony: build tag push clean

CLOUDWATCH_LOGS_PLUGIN_VERSION = 0.4.0
KUBERNETES_PLUGIN_VERSION = 0.26.2
SYSTEMD_PLUGIN_VERSION = 0.0.7

VERSION = $(shell git rev-parse --abbrev-ref HEAD)
BUILD_DATE = $(shell date +"%Y%m%d")

TAG = $(VERSION)-$(BUILD_DATE)
PREFIX = quay.io/widen/fluentd-k8s-cloudwatch-logs

build:
	docker build --pull \
		--build-arg CLOUDWATCH_LOGS_PLUGIN_VERSION=$(CLOUDWATCH_LOGS_PLUGIN_VERSION) \
		--build-arg KUBERNETES_PLUGIN_VERSION=$(KUBERNETES_PLUGIN_VERSION) \
		--build-arg SYSTEMD_PLUGIN_VERSION=$(SYSTEMD_PLUGIN_VERSION) \
		-t $(PREFIX):$(TAG) .

tag: build
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(VERSION)

push: tag
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(VERSION)

clean:
	docker rmi -f $(PREFIX):$(TAG) || true
	docker rmi -f $(PREFIX):$(VERSION) || true
