#include <stdlib.h>
#include <stdio.h>

#include "ed25519.h"

#include "ge.h"
#include "sc.h"

typedef uint8_t u8;

#define ARRAY(name, size) \
    u8 name[size]; \
    for(size_t i = 0; i < size; i++) name[i] = 123;

void audit(void) {
    ARRAY(seed, 32);
    ARRAY(pub,  32);
    ARRAY(key,  32);
    ARRAY(hash, 64);

    ed25519_create_keypair(pub, key, seed);
    ed25519_sign(hash, seed, 32, pub, key);
    ed25519_verify(hash, seed, 32, pub);
    return 0;
}
