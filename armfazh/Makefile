all:
	gcc -fPIC -c x25519_x64.c
	gcc -fPIC -c fp25519_x64.c
	gcc -shared -Wl,-soname,libarmfazh.so.0 -o libarmfazh.so.0 fp25519_x64.o x25519_x64.o -lc
	sudo cp -uf libarmfazh.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
