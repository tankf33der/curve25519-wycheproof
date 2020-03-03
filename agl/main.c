#include <stdio.h>
#include <stdint.h>
//#include "curve25519.h"

int main() {
	uint8_t k[32] = {9};
	uint8_t u[32] = {66, 44, 142, 122, 98, 39, 215, 188, 161, 53, 11, 62, 43, 183, 39, 159, 120, 151, 184, 123, 182, 133, 75, 120, 60, 96, 232, 3, 17, 174, 48, 121};
	uint8_t r[32];

	curve25519_donna(r, u, k);
	printf("%d\n", r[0]);
	return 0;

}
