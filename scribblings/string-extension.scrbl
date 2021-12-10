#lang scribble/manual
@require[@for-label[string-extension
                    racket/base]]

@title{string-extension}
@author{linzizhuan}

@defmodule[string-extension]

The language extends racket string to get formatted string, let's look at the following example.

@racketblock[
(define-values (x y z) (values 1 2 3))
"x = $x, y = $y, z = $z, (+ x y z) = $(+ x y z)"
]
