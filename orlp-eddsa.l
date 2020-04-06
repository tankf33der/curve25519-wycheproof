`(== 64 64)
(seed (in "/dev/urandom" (rd 8)))
(de hex2L (H)
   (make
      (for (L (chop H) L (cddr L))
         (link (hex (pack (car L) (cadr L)))) ) ) )
(de L2hex (Lst)
   (lowc
      (pack
         (mapcar '((B) (pad 2 (hex B))) Lst) ) ) )
(de randL (N)
   (make (do N (link (rand 0 255)))) )
(de check_c (Sig P M)
   (let ML (length M)
      (if
         (=1
            (native
               "liborlp.so.0"
               "ed25519_verify"
               'I
               (cons NIL (64) Sig)
               (cons NIL (cons ML) M)
               ML
               (cons NIL (32) P) ) )
         0
         -1 ) ) )
(de check_m (Sig P M)
   (let ML (length M)
      (native
         "libmonocypher.so"
         "crypto_ed25519_check"
         'I
         (cons NIL (64) Sig)
         (cons NIL (32) P)
         (if M (cons NIL (cons ML) M) 0)
         ML ) ) )
(test -1 (check_c (need 64 0) (need 32) 0 0))
# XXX, test valid library
(test
   0
   (check_c
      (hex2L "d80737358ede548acb173ef7e0399f83392fe8125b2ce877de7975d8b726ef5b1e76632280ee38afad12125ea44b961bf92f1178c9fa819d020869975bcbe109")
      (hex2L "7d4d0e7f6153a69b6242b522abbee685fda4420f8834b108c3bdae369ef549fa")
      (hex2L "78") ) )
(test
   -1
   (check_c
      (hex2L "edffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7fedffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f")
      (hex2L "7d4d0e7f6153a69b6242b522abbee685fda4420f8834b108c3bdae369ef549fa")
      (hex2L "3f") ) )
# XXX, done
(let (S (need 64 0)  P (need 32 0)  M)
   (setq M (94 25 120))
   (set (nth P 32) 128)
   (test (check_m S P M) (check_c S P M))
   (setq M (102 203 46))
   (test (check_m S P M) (check_c S P M)) )
(let (S (need 64 0)  P (need 32 0)  M (need 64 0))
   (set (nth P 32) 128)
   (for X (range 0 255)
      (set M X)
      (test
         (check_m S P M)
         (check_c S P M) ) ) )
# Lets go
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
         (unless (= Result (check_c Sig Pk Msg))
            (printsp C) ) ) ) )
(prinl)
(test 145 C) # check EOF

(msg 'orlp-eddsa-OK)
(bye)

