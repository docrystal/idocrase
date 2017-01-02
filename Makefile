SOURCES := $(shell find . -name "*.cr")

.PHONY: example
example: bin/example

bin/example: $(SOURCES)
	@mkdir -p bin
	@crystal build --debug -o bin/example example/app.cr
