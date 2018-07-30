BIN ?= mysqlchangeprefix
PREFIX ?= /usr/local

install:
	cp mysqlchangeprefix.sh $(PREFIX)/bin/$(BIN)
	chmod +x $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
