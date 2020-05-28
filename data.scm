;; Created: 2020-05-26 
;; Revised: 2020-05-28 
;; Functions ending with double exclamation marks (!!) should not be used directly,
;; unless you know what you're doing; there should be a ! version that you should use instead.
;; This is my compromise instead of using a full OOP language like Ruby that
;; allows enforced access.
(import (srfi srfi-9))



(define (create-project! title keyword life-context)
  ;; Creates the project, adds it to the data structure.
  (list title keyword life-context))


(define-record-type project
  (make-project!! title keyword life-context)
  project?
  (title project-title set-project-title!)
  (keyword project-keyword set-project-keyword!)
  (life-context project-life-context set-project-life-context!) ; if unspecified, set to personal. TODO at the UI level or one level up minimimu from here
  (tags project-tags set-project-tags!)
  (tasks project-tasks set-project-tasks!)
  (project-support-material  set-project-support-material-text!)
  (creation project-creation set-project-creation!)
  (modified project-modified set-project-modified!)
  (last-reviewed project-last-reviewed set-project-last-reviewed!)
  (completed project-completed set-project-completed!)
  (deleted project-deleted set-project-deleted!)
  (notes project-notes set-project-notes!!)) ;; double !! b/c you shouldn't use this directly, you should call a helper function that timestamps them, such as (add-note note-contents)

;; test case
(define test-project (make-project "Ensure extbrain has a comprehensive test suite with SRFI-64" "extbrain-test" "personal"))
   
