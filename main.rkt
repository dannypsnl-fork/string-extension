#lang racket/base

(module reader racket
  (provide (rename-out [literal-read read]
                       [literal-read-syntax read-syntax]))

  (require syntax/strip-context
           syntax/to-string
           racket/syntax-srcloc)

  (define (literal-read in) (syntax->datum (literal-read-syntax #f in)))

  (define (convert src origin-stx S)
    (define idx (string-index S "$"))
    (if idx
        (let* ([exp (read-syntax src (open-input-string (substring S (add1 idx))))]
               [end-idx (+ idx (string-length (~a (syntax->datum exp))))]
               [after-stx (convert src origin-stx (substring S (add1 end-idx)))])
          (with-syntax ([fmt (string-append (substring S 0 idx) "~a")]
                        [e exp]
                        [a-stx after-stx])
            (syntax/loc
                (syntax-srcloc origin-stx)
              (format (string-append fmt a-stx) e))))
        (syntax/loc (syntax-srcloc origin-stx) "")))
  (define (literal-read-syntax src in)
    (define ss
      (let loop ([r '()])
        (define stx (read-syntax src in))
        (if (eof-object? stx)
            r
            (loop (append r (list stx))))))
    (with-syntax ([(s ...) (map (lambda (s)
                                  (if (string? (syntax->datum s))
                                      (let ()
                                        (define S (syntax->datum s))
                                        (convert src s S))
                                      s))
                                ss)])
      (strip-context
       #'(module anything racket/base
           s ...))))

  (define (string-index hay needle)
    (define n (string-length needle))
    (define h (string-length hay))
    (and (<= n h) ; if the needle is longer than hay, then the needle can not be found
         (for/or ([i (- h n -1)]
                  #:when (string=? (substring hay i (+ i n)) needle))
           i))))
