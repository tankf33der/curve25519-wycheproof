all:
	gcc -fPIC -c curve25519_dh.c
	gcc -fPIC -c curve25519_order.c
	gcc -fPIC -c curve25519_utils.c
	gcc -fPIC -c custom_blind.c
	gcc -fPIC -c ed25519_sign.c
	gcc -fPIC -c sha512.c
	gcc -fPIC -c curve25519_mehdi.c
	gcc -shared -Wl,-soname,libmsotoodeh.so.0 -o libmsotoodeh.so.0 curve25519_utils.o custom_blind.o curve25519_order.o curve25519_mehdi.o sha512.o ed25519_sign.o curve25519_dh.o -lc
	sudo cp -uf libmsotoodeh.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
