all: help

# Makefile for installation of dyfi-update.pl

# For BSD install: Which install to use and where to put the files
INSTALL = install
PREFIX  = /usr/local
BIN_DIR = $(PREFIX)/bin
ETC_DIR = $(PREFIX)/etc
MAN_DIR = $(PREFIX)/man

clean:
	rm -f *.o *~ *.bak core
distclean: clean

install: installboot installconf installbin

installbin:
	$(INSTALL) -d -o root -g root -m 755 $(BIN_DIR)
	$(INSTALL) -m 755 -o root -g root dyfi-update.pl $(BIN_DIR)
	@echo ""
	@echo "dyfi-update.pl has been installed in $(BIN_DIR)."
	@echo "To install the boot script, figure out your default runlevel"
	@echo "(hint: grep initdefault /etc/inittab)"  
	@echo "and run 'make installboot2', 'make installboot5' or whatever"
	@echo "you happen to use. RedHat typically runs at 3 or 5."
	@echo ""

installboot:
	$(INSTALL) -m 755 -o root -g root dyfi-update /etc/init.d

installboot0: installboot
	@if [ ! -e /etc/rc0.d/K01dyfi-update ]; then cd /etc/rc0.d; ln -s ../init.d/dyfi-update K01dyfi-update; fi

installboot1: installboot
	@if [ ! -e /etc/rc1.d/K01dyfi-update ]; then cd /etc/rc1.d; ln -s ../init.d/dyfi-update K01dyfi-update; fi

installboot2: installboot installboot0 installboot1 installboot6
	@if [ -f /etc/rc2.d/S99dyfi-update ]; then echo "Already configured at runlevel 2."; exit 1; fi
	cd /etc/rc2.d && ln -s ../init.d/dyfi-update S99dyfi-update

installboot3: installboot installboot0 installboot1 installboot6
	@if [ -f /etc/rc3.d/S99dyfi-update ]; then echo "Already configured at runlevel 3."; exit 1; fi
	cd /etc/rc3.d && ln -s ../init.d/dyfi-update S99dyfi-update

installboot4: installboot installboot0 installboot1 installboot6
	@if [ -f /etc/rc4.d/S99dyfi-update ]; then echo "Already configured at runlevel 4."; exit 1; fi
	cd /etc/rc4.d && ln -s ../init.d/dyfi-update S99dyfi-update

installboot5: installboot installboot0 installboot1 installboot6
	@if [ -f /etc/rc5.d/S99dyfi-update ]; then echo "Already configured at runlevel 5."; exit 1; fi
	cd /etc/rc5.d && ln -s ../init.d/dyfi-update S99dyfi-update

installboot6: installboot
	@if [ ! -e /etc/rc6.d/K01dyfi-update ]; then cd /etc/rc6.d; ln -s ../init.d/dyfi-update K01dyfi-update; fi

installconf:
	$(INSTALL) -d -o root -g root -m 755 $(ETC_DIR)
	@if [ -f $(ETC_DIR)/dyfi-update.conf ]; then \
		echo ""; \
		echo "Configuration file already installed. Run 'make forceinstallconf' to overwrite."; \
		echo ""; \
	else \
		echo "Installing config in $(ETC_DIR)."; \
		echo "Remember to edit dyfi-update.conf afterwards!"; \
		$(INSTALL) -m 644 -o root -g root dyfi-update.conf $(ETC_DIR); \
	fi
		
forceinstallconf:
	@echo "Overwriting config in $(ETC_DIR)."
	$(INSTALL) -d -o root -g root -m 755 $(ETC_DIR)
	$(INSTALL) -m 644 -o root -g root dyfi-update.conf $(ETC_DIR)

uninstall:
	@echo "Uninstalling dyfi-update..."
	@echo ""
	rm /etc/rc?.d/S99dyfi-update /etc/rc?.d/K01dyfi-update || exit 0
	rm /etc/init.d/dyfi-update || exit 0
	rm $(ETC_DIR)/dyfi-update.conf || exit 0
	rm $(BIN_DIR)/dyfi-update.pl || exit 0

help:
	@echo "This make file only knows how to install or uninstall."



