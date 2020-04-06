#include "ed25519.h"
#include <stdint.h>

#ifndef ED25519_NO_SEED

#ifdef _WIN32
#include <windows.h>
#include <wincrypt.h>
#else
#include <stdio.h>
#endif


uint64_t random_state = 4554566766;

// Pseudo-random 64 bit number, based on xorshift*
uint64_t rand64()
{
    random_state ^= random_state >> 12;
    random_state ^= random_state << 25;
    random_state ^= random_state >> 27;
    return random_state * 0x2545F1177F6CDD1D; // magic constant
}



int ed25519_create_seed(unsigned char *seed) {
/*
#ifdef _WIN32
    HCRYPTPROV prov;

    if (!CryptAcquireContext(&prov, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))  {
        return 1;
    }

    if (!CryptGenRandom(prov, 32, seed))  {
        CryptReleaseContext(prov, 0);
        return 1;
    }

    CryptReleaseContext(prov, 0);
#else
    FILE *f = fopen("/dev/urandom", "rb");

    if (f == NULL) {
        return 1;
    }

    fread(seed, 1, 32, f);
    fclose(f);
#endif
*/
    for(int i = 0; i < 32; i++) {
        seed[i] = (uint8_t)rand64();
    }

    return 0;
}

#endif
