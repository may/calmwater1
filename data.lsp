; timestamp is date-value, worry about 2038 in 2037 haha.
(setq savefile-filename "savefile-dev.lsp")
(if (file? savefile-filename) ; should only be needed on first run
    (load savefile-filename))
(if (not latest-uid) (setq latest-uid 0)) ; should only be needed on first run



;; example
  ;; (1 (title "Hello world this is my first task") (creation-timestamp 1234)) 
  ;; (2 (title "This is my second task")) 
  ;; (3 (title "This is my test PROJECT") (creation 12345) (next-task-uid 3) (tasks 
  ;;   (1 "I'm a task inside a project!") 
  ;;   (2 "I'm also the SECOND task inside a project!")))))



;; todo once you have tasks working in projcets, probablly update this to not update notes
;; Updates the property specified by property-param, except notes.
;; Do not use with notes.
;; Will destructively replace contents of existing param in uid.
;; Updates projects-and-tasks global directly.
(define (update-property! uid property-param updated-param)
  (setq old-property (lookup property-param (assoc uid projects-and-tasks)))
  (setq new-property updated-param)
  (add-note
   (format "Updated %s:\n\r old: %s\n\r new:"
	   property-param old-property new-property))
  (setq (lookup property-param (assoc uid projects-and-tasks)) new-property))

; todo (define (add-note)) // update-note
  ;; every subsequent addition to the notes list should be done this way:
  ;; (push (list datetimeasseconds1234 "contents of note") (assoc 'notes task-or-project) 1) ;; pushing to 0 breaks assoc list -NEM


