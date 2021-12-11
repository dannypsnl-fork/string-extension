string-extension
================
All works moved to https://github.com/dannypsnl/formatted-string, which provided even better experience by using meta-reader.

The language extends racket string to formatted string, let's look at the following example.

```racket
#lang string-extension

(define-values (x y z) (values 1 2 3))
"x = $x, y = $y, z = $z, (+ x y z) = $(+ x y z)"
```
