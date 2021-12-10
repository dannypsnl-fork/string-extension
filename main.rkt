#lang racket

(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax]))

(require racket/port
         syntax/strip-context
         racket/sequence)

(define (literal-read in) (syntax->datum (literal-read-syntax #f in)))

(define (literal-read-syntax src in)
  (define ss
    (let loop ([r '()])
      (define stx (read-syntax src in))
      (if (eof-object? stx)
          r
          (loop (append r (list stx))))))
  (set! ss
        (map (lambda (s)
               (if (string? (syntax->datum s))
                   (let ()
                     (define S (syntax->datum s))
                     (displayln (string-index S "$"))
                     s)
                   s))
             ss))
  (with-syntax ([(s ...) ss])
    (strip-context
     #'(module anything racket/base
         s ...)))
  )

(define (string-index hay needle)
  (define n (string-length needle))
  (define h (string-length hay))
  (and (<= n h) ; if the needle is longer than hay, then the needle can not be found
       (for/or ([i (- h n -1)]
                #:when (string=? (substring hay i (+ i n)) needle))
         i)))
