;; Created: 2020-05-13
;; Revised: 2020-05-13
;; Copyright: Nicholas E. May. All rights reserved.
;;
;; Add new functions & commands at the top.


;; Every piece of input into extbrain should start with a command or be a command.
;; The exception is, if no command, add new task is assumed.
;; For example: lp work
;; For example: exit
;; Add new task: some task
(define (dispatch-command user-input)
  (case user-input
    ("exit" (setq exit-extbrain true))
    (true (create-task user-input))))


(define (command-loop)
  (until exit-extbrain
    (print "> ")
    (dispatch-command (read-line))))
    

  
