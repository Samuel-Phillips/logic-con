.PHONY: all clean

all: bin/logic-con man/logic-con.1

clean:
	rm -rf lib
	rm -rf bin
	rm -rf man

bin/logic-con: lib/shell.js bin
	echo "#!/usr/bin/env nodejs" > $@
	cat $< >> $@
	chmod +x $@

lib/console.js: src/console.ls lib/syntax.js lib
	lsc -cp $< > $@ 

lib/shell.js: src/shell.ls lib/console.js lib
	lsc -cp $< > $@ 

lib/syntax.js: src/syntax.pegjs lib
	pegjs $< $@

man/%.1: mansrc/%.md mansrc/%-header.txt man
	cat mansrc/$*-header.txt > $@
	pandoc -t man $< >> $@

lib bin man:
	mkdir -p $@
