PREFIX = ~/.local

.PHONY: install man get-deps

install:
	mkdir -p $(PREFIX)/bin/
	mkdir -p $(PREFIX)/share/man/man1/
	cp picardmetrics $(PREFIX)/bin/
	cp man/picardmetrics.1 $(PREFIX)/share/man/man1/
	cp picardmetrics.conf ~/

man: man/picardmetrics.1.ronn
	ronn \
		--manual="picardmetrics manual" \
		--organization="picardmetrics-0.1.3" \
		--date="$(shell date +%Y-%m-%d)" \
		--style=toc \
		$?

get-deps:
	./scripts/install_deps

annot:
	./scripts/make_refFlat
	./scripts/make_rRNA_intervals
	echo "Edit your picardmetrics.conf file with paths to files in annot/"
