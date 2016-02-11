logic-con: shell.js
	echo "#!/usr/bin/env nodejs" > $@
	cat shell.js >> $@
	chmod +x $@

console.js: console.ls syntax.js
	lsc -cp $< > $@ 

shell.js: shell.ls console.js
	lsc -cp $< > $@ 

syntax.js: syntax.pegjs
	pegjs $< $@
