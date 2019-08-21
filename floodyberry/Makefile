all:
	gcc -fPIC -c curve25519.c
	gcc -shared -Wl,-soname,libfloodyberry.so.0 -o libfloodyberry.so.0 curve25519.o -lc
	sudo cp -uf libfloodyberry.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
