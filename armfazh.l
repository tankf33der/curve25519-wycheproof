NOT USABLE SHIT
KEEP FOR HISTORY

`(== 64 64)
(de hex2L (H)
   (make
      (for (L H L (cddr L))
         (link (hex (pack (car L) (cadr L)))) ) ) )
(de crypto_scalarmult (S P)
   (use R
      (and
         (=0
            (native
               "libarmfazh.so"
               "X25519_Shared"
               NIL
               '(R (32 B . 32))
               (cons NIL (32) P)
               (cons NIL (32) S) ) )
         R ) ) )
(println (crypto_scalarmult (need 32 0) (need 32 255)))
(bye)

(in "x25519_test.csv"
   (until (eof)
      (let
         (SK (prog1 (hex2L (till ",")) (char))
            PK (prog1 (hex2L (till ",")) (char))
            SH (prog (hex2L (line))) )
         (test SH (crypto_scalarmult SK PK)) ) ) )
(msg 'tweetnacl-ok)
(bye)


