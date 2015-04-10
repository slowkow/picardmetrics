PREFIX = ~/.local

.PHONY: install man

install:
	mkdir -p $(PREFIX)/bin/
	mkdir -p $(PREFIX)/share/man/man1/
	cp picardmetrics $(PREFIX)/bin/
	cp man/picardmetrics.1 $(PREFIX)/share/man/man1/
	cp picardmetricsrc ~/.picardmetricsrc

man: man/picardmetrics.1.ronn
	ronn \
		--manual="picardmetrics manual" \
		--organization="picardmetrics-0.1.2" \
		--style=toc \
		$?
