PHONY: build
build:
	rm -rf ./docs
	hugo --destination=./docs
	touch ./docs/.nojekyll
	echo www.generictestdomain.net >./docs/CNAME
