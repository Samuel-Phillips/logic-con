console.js: console.ls syntax.js
	lsc -cp $< > $@ 

syntax.js: syntax.pegjs
	pegjs $< $@
