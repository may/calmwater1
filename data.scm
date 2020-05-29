;; Created: 2020-05-26 
;; Revised: 2020-05-28 

;; guile:
(import (srfi srfi-9))

(define projects-and-tasks (list))

(define-record-type project
x  (make-project title keyword life-context)
x  project?
x  (title title set-title!)
x  (keyword keyword set-keyword!)
x  (life-context life-context set-life-context!) 
x  (tags tags set-tags!)
X  (tasks tasks set-tasks!)
x  (psm psm set-psm-text!) ; project support material
x  (creation creation set-creation!)
x  (modified modified set-modified!)
x  (last-reviewed last-reviewed set-last-reviewed!)
x  (completed completed set-completed!)
x  (deleted deleted set-deleted!)
x  (notes notes set-notes!))

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
  (map projects-and-tasks
       print title: etc.
       
  
  (write projects-and-tasks out)
  (close-port out)) ;; guile

;; chicken 5
;;(import srfi-9)
;;(import (chicken file))
