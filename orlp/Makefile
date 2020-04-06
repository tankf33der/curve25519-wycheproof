all: c a m u
a: c
	clang -fsanitize=address *.c && ./a.out
m: c
	clang -fsanitize=memory *.c && ./a.out
u: c
	clang -fsanitize=undefined *.c && ./a.out
mike:
	cat *.c > mike.c
ccomp: c mike
	ccomp -fstruct-passing mike.c && ./a.out
interp: c mike
	ccomp -interp -quiet -fstruct-passing mike.c
c:
	rm -rf *.o *.out mike.c
lib:
	gcc -fPIC -c add_scalar.c
	gcc -fPIC -c fe.c
	gcc -fPIC -c ge.c
	gcc -fPIC -c key_exchange.c
	gcc -fPIC -c keypair.c
	gcc -fPIC -c sc.c
	gcc -fPIC -c seed.c
	gcc -fPIC -c sha512.c
	gcc -fPIC -c sign.c
	gcc -fPIC -c verify.c
	gcc -shared -Wl,-soname,liborlp.so.0 -o liborlp.so.0 *.o -lc
	sudo cp -uf liborlp.so.0 /usr/local/lib
	sudo ldconfig
