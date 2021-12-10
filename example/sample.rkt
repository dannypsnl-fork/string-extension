#lang reader string-extension

(require racket/format)

(define x 1)

"x = $x"
"(+ 1 2 3) = $(+ 1 2 3)"
(~a (+ x x x))

x