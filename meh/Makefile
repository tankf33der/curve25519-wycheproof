all:
	gcc -fPIC -c curve25519.c
	gcc -shared -Wl,-soname,libmeh.so.0 -o libmeh.so.0 curve25519.o -lc
	sudo cp -uf libmeh.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
