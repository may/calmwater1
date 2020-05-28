;; Created: 2020-05-26 
;; Revised: 2020-05-28 

;; guile:
(import (srfi srfi-9))

(define projects-and-tasks (list))

(define-record-type project
  (make-project title keyword life-context)
  project?
  (title title set-title!)
  (keyword keyword set-keyword!)
  (life-context life-context set-life-context!) 
  (tags tags set-tags!)
  (tasks tasks set-tasks!)
  (psm psm set-psm-text!) ; project support material
  (creation creation set-creation!)
  (modified modified set-modified!)
  (last-reviewed last-reviewed set-last-reviewed!)
  (completed completed set-completed!)
  (deleted deleted set-deleted!)
  (notes notes set-notes!))

;; test case
;;(define test-project (make-project "Ensure extbrain has a comprehensive test suite with SRFI-64" "extbrain-test" "personal"))

(define-record-type task
  (make-task title action-context)
  task?
  (title title set-title!)
  (action-context action-context set-action-context!))

(define (create-project! title keyword life-context)
  ;; Creates the project, adds it to the data structure.
  (define new-project)
  (set! new-project
	(list (make-project title keyword life-context)))
  (if (null? projects-and-tasks)
      (set! projects-and-tasks new-project)
      (append! projects-and-tasks new-project))) ;; appending to end to make savefile chronological readable.






;;todo(define (add-note note-contents)
  ;; append the noet with a timestamp to the top of the notes list


; in the ui ,if user didn't set life context, default ot personal or prompt, your choice
; if unspecified, set to personal. TODO at the UI level or one level up minimimu from here






(define (load-data)
  (define in (open-input-file savefile-filename))
  (set! projects-and-tasks (read in))
  (close-port in)) ;; guile

(define (save-data)
  (define out (open-output-file savefile-filename))
  (display projects-and-tasks)
  (write projects-and-tasks out)
  (close-port out)) ;; guile

;; chicken 5
;;(import srfi-9)
;;(import (chicken file))
