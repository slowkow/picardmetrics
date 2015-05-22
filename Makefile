PREFIX = ~/.local

.PHONY: all install man get-deps data

all:
	@echo "Run 'make get-deps' to download and install dependencies in $(PREFIX)"
	@echo "Run 'make install' to install picardmetrics files in $(PREFIX)"
	@echo "Run 'make data' to download and create human reference files in ./data"

install:
	mkdir -p $(PREFIX)/bin/
	mkdir -p $(PREFIX)/share/man/man1/
	cp picardmetrics $(PREFIX)/bin/
	cp man/picardmetrics.1 $(PREFIX)/share/man/man1/
	cp picardmetrics.conf ~/

man: man/picardmetrics.1.ronn
	ronn \
		--manual="picardmetrics manual" \
		--organization="picardmetrics-0.1.4" \
		--date="$(shell date +%Y-%m-%d)" \
		--style=toc \
		$?

get-deps:
	./scripts/install_deps $(PREFIX)

data:
	mkdir -p data
	./scripts/make_refFlat
	./scripts/make_rRNA_intervals
	@echo
	@echo "Edit your picardmetrics.conf file with paths to files in ./data"
