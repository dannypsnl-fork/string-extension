#lang racket

(provide (rename-out [literal-read read]
                     [literal-read-syntax read-syntax]))

(require syntax/strip-context
         syntax/to-string
         racket/syntax-srcloc)

(define (literal-read in) (syntax->datum (literal-read-syntax #f in)))

(define (convert src origin-stx S)
  (define idx (string-index S "$"))
  (define exp (read-syntax src (open-input-string (substring S (add1 idx)))))
  (define end-idx (+ idx (string-length (~a (syntax->datum exp)))))
  (define before-str (substring S 0 idx))
  (define after-str (substring S (add1 end-idx)))
  (with-syntax ([fmt (string-append before-str "~a" after-str)]
                [e exp])
    (syntax/loc
        (syntax-srcloc origin-stx)
      (format fmt e))))
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
                     (convert src s S))
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
