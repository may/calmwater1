;; Created: 2020-05-26 
;; Revised: 2020-05-28 

;; guile:
(import (srfi srfi-9))


(define savefile-filename "savefile-dev.scm")

(define-record-type project
  (make-project title keyword life-context)
  project?
  (title project-title set-project-title!)
  (keyword project-keyword set-project-keyword!)
  (life-context project-life-context set-project-life-context!) 
  (tags project-tags set-project-tags!)
  (tasks project-tasks set-project-tasks!)
  (project-support-material  set-project-support-material-text!)
  (creation project-creation set-project-creation!)
  (modified project-modified set-project-modified!)
  (last-reviewed project-last-reviewed set-project-last-reviewed!)
  (completed project-completed set-project-completed!)
  (deleted project-deleted set-project-deleted!)
  (notes project-notes set-project-notes!))

;; test case
;;(define test-project (make-project "Ensure extbrain has a comprehensive test suite with SRFI-64" "extbrain-test" "personal"))


(define (create-project! title keyword life-context)
  ;; Creates the project, adds it to the data structure.
  (display (list title keyword life-context))
  (append! projects-and-tasks (list (make-project title keyword life-context))))






;;todo(define (add-note note-contents)
  ;; append the noet with a timestamp to the top of the notes list


; in the ui ,if user didn't set life context, default ot personal or prompt, your choice
; if unspecified, set to personal. TODO at the UI level or one level up minimimu from here



(define projects-and-tasks)
(define (load-data)
  (define in (open-input-file savefile-filename))
  (set! projects-and-tasks (read in))
  (close-port in)) ;; guile

(if (file-exists? savefile-filename)
    (load-data))

(display projects-and-tasks)


;; chicken 5
;;(import srfi-9)
;;(import (chicken file))
