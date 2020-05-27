;; Created: 2020-05-26 
;; Revised: 2020-05-26 

(import (srfi srfi-9))
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
  (notes project-notes set-project-notes))

;; test case
(define test-project (make-project "Ensure extbrain has a comprehensive test suite with SRFI-64" "extbrain-test" "personal"))
   
