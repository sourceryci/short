.PHONY: $(MAKECMDGOALS)

OS_NAME := $(shell uname -s | tr A-Z a-z)
ifeq ($(OS_NAME),darwin)
OPEN = open
else
OPEN = xdg-open
endif

# `make setup` will be used after cloning or downloading to fulfill
# dependencies, and setup the the project in an initial state.
# This is where you might download rubygems, node_modules, packages,
# compile code, build container images, initialize a database,
# anything else that needs to happen before your server is started
# for the first time
setup:
	docker-compose run --rm app mix setup

# `make server` will be used after `make setup` in order to start
# an http server process that listens on any unreserved port
# of your choice (e.g. 8080).
server:
	docker-compose up

# Start a server with an interactive IEx session
console:
	docker-compose run --rm --service-ports app iex -S mix phx.server

# `make test` will be used after `make setup` in order to run
# your test suite.
test:
	docker-compose run --rm app mix test --cover

lint:
	docker-compose run --rm app mix format --check-formatted --dry-run

# Generate docs and view then in the browser
docs:
	docker-compose run --rm app mix docs && $(OPEN) doc/index.html
