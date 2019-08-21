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
               "libagl.so.0"
               "curve25519_donna"
               'I
               '(R (32 B . 32))
               (cons NIL (32) S)
               (cons NIL (32) P) ) )
         R ) ) )
(in "x25519_test.csv"
   (until (eof)
      (let
         (SK (prog1 (hex2L (till ",")) (char))
            PK (prog1 (hex2L (till ",")) (char))
            SH (prog (hex2L (line))) )
         (test SH (crypto_scalarmult SK PK)) ) ) )
# also, lets check for RFC
(let (Prv (need 32 0)  Base (need 32 0))
   (set Prv 9  Base 9)
   (test
      (66 44 142 122 98 39 215 188 161 53 11 62 43 183 39 159 120 151 184 123 182 133 75 120 60 96 232 3 17 174 48 121)
      (setq Prv (crypto_scalarmult Prv Base)) )
   (do 1000
      (setq
         Base
         (swap
            'Prv
            (crypto_scalarmult Prv Base) ) ) )
   (test
      (104 76 245 155 168 51 9 85 40 0 239 86 111 47 77 60 28 56 135 196 147 96 227 135 95 46 185 77 153 83 44 81)
      Base ) )
(msg 'agl-ok)
(bye)
