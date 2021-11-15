SUBDIRS := $(wildcard */.)

all: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@

people.rules: people.txt people.sh
	./people.sh < people.txt > people.rules

.PHONY: all $(SUBDIRS)
