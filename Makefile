# Makefile for the autorevision project

VERS=$(shell ./autorevision -o autorevision.tmp -s VCS_TAG | sed -e 's:refs/heads/::' -e 's:v/::')

.SUFFIXES: .md .html

.md.html:
	markdown $< >$@

MANDIR=/usr/share/man/man1
BINDIR=/usr/bin

DOCS    = README.md COPYING.md CONTRIBUTING.md autorevision.asc NEWS
SOURCES = autorevision Makefile $(DOCS) control
EXTRA_DIST = autorevision.tmp

all: autorevision-$(VERS).tar.gz

install: autorevision.1
	cp autorevision 
	gzip <autorevision.1 >$(MANDIR)/autorevision.1.gz
	rm autorevision.1

uninstall:
	rm -f $(BINDIR)/autorevision $(MANDIR)/autorevision.1.gz

autorevision.1: autorevision.asc
	a2x -f manpage autorevision.asc

autorevision.html: autorevision.asc
	a2x -f xhtml autorevision.asc

autorevision-$(VERS).tar.gz: $(SOURCES) autorevision.1 
	mkdir autorevision-$(VERS)
	cp -r $(SOURCES) autorevision-$(VERS)
	tar -czf autorevision-$(VERS).tar.gz autorevision-$(VERS)
	rm -fr autorevision-$(VERS)
	ls -l autorevision-$(VERS).tar.gz

dist: autorevision-$(VERS).tar.gz

clean:
	rm -f autorevision.html autorevision.1 *.tar.gz
	rm -f autorevision.tmp docbook-xsl.css
	rm -f *~  SHIPPER.* index.html

release: autorevision-$(VERS).tar.gz autorevision.html README.html COPYING.html CONTRIBUTING.html
	shipper -u -m -t; make clean
