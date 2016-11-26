haxe -lib dat.GUI -lib eventemitter3 -lib gsap -lib howlerjs -lib perf.js -lib pixi-flump-runtime -lib pixijs -lib WebFont -cp src -js bin/ui.js -xml doc/doc.xml com\isartdigital\perle/Main.hx

@echo off

:waitloop

if exist doc/doc.xml (
	goto waitloopend
) else (
	timeout /t 1
	goto waitloop
)

: waitloopend

@echo on

haxelib run dox -i doc -o doc/pages -in com.isartdigital.perle
haxelib run haxeumlgen dot --outdir=doc/packages --exclude=com.isartdigital.utils,com.isartdigital.services,_EReg,_List,_UInt,eventemitter3,webfont,howler,flump,dat,pixi,haxe,Root,js,com.greensock doc/doc.xml 
haxelib run haxeumlgen dot --outdir=doc/full -i -n --merge=com.isartdigital.perle:Builder --exclude=com.isartdigital.utils,com.isartdigital.services,_EReg,_List,_UInt,eventemitter3,webfont,howler,flump,dat,pixi,haxe,Root,js,com.greensock  doc/doc.xml 

pause