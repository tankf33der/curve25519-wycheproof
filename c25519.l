# https://www.dlbeer.co.nz/oss/c25519.html
`(== 64 64)
(de hex2L (H)
   (make
      (for (L H L (cddr L))
         (link (hex (pack (car L) (cadr L)))) ) ) )
(de crypto_scalarmult (S P)
   (let (NewS (copy S)  R)
      (set
         NewS (& (car NewS) 248)
         (nth NewS 32) (& (get NewS 32) 127)
         (nth NewS 32) (| (get NewS 32) 64) )
      (native
         "libc25519.so.0"
         "c25519_smult"
         NIL
         '(R (32 B . 32))
         (cons NIL (32) P)
         (cons NIL (32) NewS) )
      R ) )
(zero C)
(in "x25519_test.csv"
   (until (eof)
      (let
         (SK (prog1 (hex2L (till ",")) (char))
            PK (prog1 (hex2L (till ",")) (char))
            SH (prog (hex2L (line))) )
         (inc 'C)         
         (unless (= SH (crypto_scalarmult SK PK))
            (printsp C) ) ) ) )
(prinl)
# also, lets check for RFC
(let (Prv (need 32 0)  Base (need 32 0) PreP)
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
(msg 'c25519-ok)
(bye)

