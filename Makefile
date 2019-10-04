all: build test

build:
	dune build @install

test:
	dune build @runtest

clean:
	dune clean

.PHONY: clean all test build
