;; Created: 2020-05-28
;; Revised: 2020-05-28 
(load "data.scm")

(define savefile-filename "savefile-dev.scm")


(if (file-exists? savefile-filename)
    (load-data))
(display "loaded data") (newline)
(display projects-and-tasks)(newline)
;;(create-project! "Test project during dev." "tp" "personal") 
(save-data)
