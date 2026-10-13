VERSION := 0.$(shell git rev-list --count HEAD)
PKG := audiobible-titles
STAGING := build/staging/$(PKG)
TITLES := $(STAGING)$(PREFIX)/share/scriptures/audio/titles

.PHONY: deb clean

deb:
	test -n "$(PREFIX)"
	rm -rf $(STAGING)
	mkdir -p $(TITLES)
	cp *.mp3 *.csv $(TITLES)/
	mkdir -p $(STAGING)/DEBIAN
	find $(STAGING) -type d -exec chmod 0755 {} +
	find $(STAGING) -type f -exec chmod 0644 {} +
	sed -e 's/@VERSION@/$(VERSION)/' \
	    -e "s/@SIZE@/$$(du -sk $(STAGING) | cut -f1)/" \
	    debian/control.in > $(STAGING)/DEBIAN/control
	mkdir -p build/dist
	debian/fast-build.sh $(STAGING) build/dist/$(PKG)_$(VERSION)_all.deb

clean:
	rm -rf build
