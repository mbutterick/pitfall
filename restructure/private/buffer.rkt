#lang reader (submod "racket.rkt" reader)
(require "number.rkt" "utils.rkt")
(provide (all-defined-out))

#|
approximates
https://github.com/mbutterick/restructure/blob/master/src/Buffer.coffee
|#

#|
A Buffer is a container object for any data object that supports random access
A Node Buffer object is basically a byte string.
First argument must be a string, Buffer, ArrayBuffer, Array, or array-like object.
A Restructure RBuffer object is separate.
|#

(define (+Buffer xs [type #f])
  ((if (string? xs)
       string->bytes/utf-8
       list->bytes) xs))

(define-subclass RestructureBase (RBuffer [len #xffff])
  
  (define/override (decode stream [parent #f])
    (define decoded-len (resolve-length len stream parent))
    (send stream readBuffer decoded-len))

  (define/override (size [val #f] [parent #f])
    (when val (unless (bytes? val)
                (raise-argument-error 'Buffer:size "bytes" val)))
    (if val
        (bytes-length val)
        (resolve-length len val parent)))

  (define/override (encode stream buf [parent #f])
    (unless (bytes? buf)
      (raise-argument-error 'Buffer:encode "bytes" buf))
    (when (NumberT? len)
      (send len encode stream (length buf)))
    (send stream writeBuffer buf)))

(define-subclass RBuffer (BufferT))


#;(test-module
   (require "stream.rkt")
   (define stream (+DecodeStream #"\2BCDEF"))
   (define S (+String uint8 'utf8))
   (check-equal? (send S decode stream) "BC")
   (define os (+EncodeStream))
   (send S encode os "Mike")
   (check-equal? (send os dump) #"\4Mike")
   (check-equal? (send (+String) size "foobar") 6))