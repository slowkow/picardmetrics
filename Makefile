PREFIX = ~/.local

.PHONY: all install man get-deps

all:
	@echo "Run 'make get-deps' to download and install dependencies in $(PREFIX)"
	@echo "Run 'make install' to install picardmetrics files in $(PREFIX)"

install:
	mkdir -p $(PREFIX)/bin/
	mkdir -p $(PREFIX)/share/man/man1/
	cp picardmetrics $(PREFIX)/bin/
	cp man/picardmetrics.1 $(PREFIX)/share/man/man1/
	cp picardmetrics.conf ~/

man: man/picardmetrics.1.ronn
	ronn \
		--manual="picardmetrics manual" \
		--organization="picardmetrics-0.2.4" \
		--date="$(shell date +%Y-%m-%d)" \
		--style=toc \
		$?

get-deps:
	./scripts/install_deps $(PREFIX)
