all:
	gcc -fPIC -c curve25519-donna.c -o curve25519-donna.o
	gcc -shared -Wl,-soname,libagl.so.0 -o libagl.so.0 curve25519-donna.o -lc
	sudo cp -uf libagl.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
