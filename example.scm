(import (srfi srfi-9))

(define-record-type task
  (make-task title action-context)
  task?
  (title title set-title!)
  (action-context action-context set-action-context!))

(define savefile-filename "savefile-dev.scm")
(define (load-data)
  (define in (open-input-file savefile-filename))
  (set! tasks (read in))
  (close-port in)) ;; guile

(define (save-data)
  (define out (open-output-file savefile-filename))
  (write tasks out)
  (close-port out)) ;; guile

(define tasks
  (list 
   (make-task "Test task for example purposes." "computer")))
(save-data)
(load-data)



