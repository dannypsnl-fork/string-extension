#lang reader string-extension

(require racket/format)

(define x 1)

"x = $x"
"(+ 1 2 3) = $(+ 1 2 3) end"
(~a (+ x x x))

x