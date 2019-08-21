all:
	gcc -fPIC -c tweetnacl.c
	gcc -shared -Wl,-soname,libtweetnacl.so.0 -o libtweetnacl.so.0 tweetnacl.o -lc
	sudo cp -uf libtweetnacl.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
