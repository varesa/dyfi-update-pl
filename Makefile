all: help

# Makefile for installation of dyfi-update.pl

# For BSD install: Which install to use and where to put the files
INSTALL = install
PREFIX  = /usr/local
BIN_DIR = $(PREFIX)/bin
ETC_DIR = /etc
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
	@echo ""

installboot:
	$(INSTALL) -m 644 -o root -g root dyfi-update.service /etc/systemd/system/dyfi-update.service
	systemctl daemon-reload

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
	rm /etc/systemd/system/dyfi-update.service || exit 0
	rm $(ETC_DIR)/dyfi-update.conf || exit 0
	rm $(BIN_DIR)/dyfi-update.pl || exit 0

help:
	@echo "This make file only knows how to install or uninstall."



