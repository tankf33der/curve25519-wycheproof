all:
	gcc -fPIC -c c25519.c
	gcc -fPIC -c f25519.c
	gcc -fPIC -c ed25519.c
	gcc -fPIC -c edsign.c
	gcc -fPIC -c sha512.c
	gcc -fPIC -c fprime.c
	gcc -shared -Wl,-soname,libc25519.so.0 -o libc25519.so.0 fprime.o sha512.o edsign.o ed25519.o f25519.o c25519.o -lc
	sudo cp -uf libc25519.so.0 /usr/local/lib
	sudo ldconfig
clean:
	rm -rf *.o *.0
address:
	clang -fsanitize=address main.c c25519.c f25519.c && ./a.out
memory:
	clang -fsanitize=memory main.c c25519.c f25519.c && ./a.out	
undefined:
	clang -fsanitize=undefined main.c c25519.c f25519.c && ./a.out
# cd ..
# tis-interpreter.sh c25519/main.c c25519/c25519.c c25519/f25519.c
