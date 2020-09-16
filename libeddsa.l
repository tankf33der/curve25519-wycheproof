# https://github.com/phlay/libeddsa
`(== 64 64)
(seed (in "/dev/urandom" (rd 8)))
(de randL (N)
   (make (do N (link (rand 0 255)))) )
(de hex2L (H)
   (make
      (for (L (chop H) L (cddr L))
         (link (hex (pack (car L) (cadr L)))) ) ) )
(de str2L (H)
   (mapcan
      '((N)
         (and (cdr N) (cons (hex (pack N)))) )
      (split (chop H) "," "x", "{", "}", " ") ) )
(de crypto_x25519 (S P)
   (use R
      (native
         "libmonocypher.so"
         "crypto_x25519"
         NIL
         '(R (32 B . 32))
         (cons NIL (32) S)
         (cons NIL (32) P) )
      R ) )
(de x25519 (S P)
   (use R
      (native
         "libeddsa.so"
         "x25519"
         NIL
         '(R (32 B . 32))
         (cons NIL (32) S)
         (cons NIL (32) P) )
      R ) )
(de x25519_base (S)
   (use P
      (native
         "libeddsa.so"
         "x25519_base"
         NIL
         '(P (32 B . 32))
         (cons NIL (32) S) )
      P ) )
(de crypto_scalarmult_base_soda (S)
   (use P
      (native
         "libsodium.so"
         "crypto_scalarmult_base"
         NIL
         '(P (32 B . 32))
         (cons NIL (32) S))
      P ) )
(de verify (Sig P M)
   (let ML (length M)
      (if
         (=1
            (native
               "libeddsa.so"
               "ed25519_verify"
               'I
               (cons NIL (64) Sig)
               (cons NIL (32) P)
               (cons NIL (cons ML) M)
               ML ) )
         0
         -1 ) ) )
(de genpub (S)
   (use P
      (native
         "libeddsa.so"
         "ed25519_genpub"
         NIL
         '(P (32 B . 32))
         (cons NIL (32) S) )
      P ) )
(de sign (Sig P M)
   (let ML (length M)
      (native
         "libeddsa.so"
         "ed25519_sign"
         'I
         (cons NIL (64) Sig)
         (cons NIL (32) P)
         (if M (cons NIL (cons ML) M) 0)
         ML ) ) )
(let P (conc (range 15 0) (range 0 15))
   (do 241
      (test (x25519_base P) (crypto_scalarmult_base_soda P))
      (map inc P) ) )
(let P (conc (range 0 15) (range 15 0))
   (do 241
      (test (x25519_base P) (crypto_scalarmult_base_soda P))
      (map inc P) ) )
(let P (randL 32)
   (do 1000
      (at (0 . 100) (prin ".") (flush))
      (map
         '((L)
            (inc L 2)
            (and
               (>= (car L) 256)
               (set L 0) )
            (test
               (x25519_base P)
               (crypto_scalarmult_base_soda P) ) )
         P ) ) )
(setq
   Sk
   (make
      (in "tests/precomp.txt"
         (while (line)
            (link (hex2L @)) ) ) )
   Tst
   (make
      (in "tests/precomp_curve25519.data"
         (while (line)
            (link (str2L @)) ) ) ) )
# test_base()
(mapc
   '((A B)
      (test B (x25519_base A)) )
   Sk
   Tst )
# curve25519_test.go
(setq
   S (randL 32)
   U (randL 32)
   R1 NIL
   R2 NIL )
(set (nth S 32) (& `(hex "7f") (get U 32)))
(test
   T
   (=
      (x25519 S U)
      (prog
         (set (nth S 32) (| `(hex "80") (get U 32)))
         (x25519 S U) ) ) )
(prinl)
(zero C)
(in "x25519_test.csv"
   (until (eof)
      (let
         (SK (prog1 (hex2L (till ",")) (char))
            PK (prog1 (hex2L (till ",")) (char))
            SH (prog (hex2L (line))) )
         (inc 'C)
         (unless (= SH (x25519 SK PK))
            (printsp C) ) ) ) )
(prinl)
# also, lets check for RFC
(let (Prv (need 32 0)  Base (need 32 0) PreP)
   (set Prv 9  Base 9)
   (test
      (66 44 142 122 98 39 215 188 161 53 11 62 43 183 39 159 120 151 184 123 182 133 75 120 60 96 232 3 17 174 48 121)
      (setq Prv (x25519 Prv Base)) )
   (do 1000
      (setq
         Base
         (swap
            'Prv
            (x25519 Prv Base) ) ) )
   (test
      (104 76 245 155 168 51 9 85 40 0 239 86 111 47 77 60 28 56 135 196 147 96 227 135 95 46 185 77 153 83 44 81)
      Base ) )

# ed25519 part
(test -1 (verify (need 64 0) (need 32) 0 0))
# XXX, test valid library
(test
   0
   (verify
      (hex2L "d80737358ede548acb173ef7e0399f83392fe8125b2ce877de7975d8b726ef5b1e76632280ee38afad12125ea44b961bf92f1178c9fa819d020869975bcbe109")
      (hex2L "7d4d0e7f6153a69b6242b522abbee685fda4420f8834b108c3bdae369ef549fa")
      (hex2L "78") ) )
(test
   -1
   (verify
      (hex2L "edffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7fedffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f")
      (hex2L "7d4d0e7f6153a69b6242b522abbee685fda4420f8834b108c3bdae369ef549fa")
      (hex2L "3f") ) )
(zero C)
(in "eddsa_test.csv"
   (until (eof)
      (let
         (Pk (prog1 (hex2L (till "," T)) (char))
            Sk (prog1 (hex2L (till "," T)) (char))
            Msg (prog1 (hex2L (till "," T)) (char))
            Sig (prog1 (hex2L (till "," T)) (char))
            Result (format (line)) )
         (inc 'C)
         (unless (= Result (verify Sig Pk Msg))
            (printsp C) ) ) ) )
(prinl)
(test 145 C) # check EOF
(msg 'libeddsa-OK)
(bye)
