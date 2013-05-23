all: main
	./bin/Main
#	cd bin && neko Main.n

.PHONY: lib
lib:
	haxelib run hxcpp Build.xml -DHXCPP_M64

main: haxelib Main.hx
	haxe -main Main.hx -cpp bin -D HXCPP_M64 -lib glfw3 -lib ogl

.PHONY: haxelib
haxelib: lib
	rm -f glfw3.zip
	zip -r glfw3 src glfw3 include ndll Build.xml haxelib.json
	haxelib local glfw3.zip
