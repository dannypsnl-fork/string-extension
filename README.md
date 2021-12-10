string-extension
================
The language extends racket string to get formatted string, let's look at the following example.

```racket
(define-values (x y z) (values 1 2 3))
"x = $x, y = $y, z = $z, (+ x y z) = $(+ x y z)"
```
