bin/logic-con: lib/shell.js
	echo "#!/usr/bin/env nodejs" > $@
	cat $< >> $@
	chmod +x $@

lib/console.js: src/console.ls lib/syntax.js
	lsc -cp $< > $@ 

lib/shell.js: src/shell.ls lib/console.js
	lsc -cp $< > $@ 

lib/syntax.js: src/syntax.pegjs
	pegjs $< $@
