all:
	rm -rf obj bin all_objs ndll
	make lib
	make haxelib
	make main
	make nekomain
	./bin/Main
	neko Main.n
#	cd bin && neko Main.n

.PHONY: lib
lib:
	haxelib run hxcpp Build.xml -DHXCPP_M64

main:
	haxe -main Main.hx -cpp bin -D HXCPP_M64 -lib ogl

nekomain:
	haxe -main Main.hx -neko Main.n -lib glfw3

.PHONY: haxelib
haxelib: lib
	rm -f glfw3.zip
	zip -r glfw3 src glfw3 include ndll Build.xml haxelib.json
	haxelib local glfw3.zip
