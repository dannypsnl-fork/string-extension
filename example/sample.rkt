#lang reader string-extension

(define x 1)
(define y 2)
(define z 3)

"x = $x"
"(+ 1 2 3) = $(+ 1 2 3) end"
"x = $x, y = $y"
"x = $x, y = $y, z = $z"
