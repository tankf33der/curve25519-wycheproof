all:
	gcc -fPIC -c cleanup.c
	gcc -fPIC -c fe.c
	gcc -fPIC -c fe25519.c
	gcc -fPIC -c crypto_scalarmult_curve25519.c
	gcc -fPIC -c uint32_unpack.c
	gcc -fPIC -c uint32_pack.c
	gcc -shared -Wl,-soname,libtiny.so.0 -o libtiny.so.0 cleanup.o fe.o fe25519.o uint32_unpack.o uint32_pack.o crypto_scalarmult_curve25519.o -lc
	sudo cp -uf libtiny.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
