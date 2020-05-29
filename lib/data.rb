# Created: 2020-05-28
# Revised: 2020-05-29

require 'yaml'

$time_formatting_string = "%Y-%m-%d %H:%M, %A."


## TODO $projects_and_tasks

=begin
multiline comment
is like this
=end


# store in arrays by keyword so maybe hash tables?
# potiental issue of syncing keyword in object w/ stored keyword in hash? Or simply don't duplicate?

class Project
 def Project.attr_accessor_with_logging(*names)
    attr_reader *names
    names.each do |name|
      define_method :"#{name}=" do |v|
        current_instance_variable = instance_variable_get(:"@#{name}")
        add_note("Updated #{name}:\n old: #{current_instance_variable}\n new: #{v}")
        instance_variable_set(:"@#{name}", v)
      end
    end
 end 

 # TODO test tags/do implementaiton @tags
 # TODO test tasks/do implementaiton @tasks
 # TODO test/do implementaiton @psm
 # TODO test /do implementaiton @completed
 # TODO test /do implementaiton @deleted
 
 attr_accessor :modified, :last_reviewed
 attr_accessor_with_logging :title, :keyword, :tags, :tasks, :psm, :completed, :deleted
 attr_reader :notes, :created
 
 def initialize(title, keyword, life_context)
    now = Time.now
    @title = title
    @keyword = keyword
    @life_context = life_context
    @notes = Array.new
    @notes.unshift([now,"Created: #{title}"])
    @created = now
  end

  def add_note(note_text)
    # Add notes to front of array, so that they are stored in reverse chronological order.
    @notes.unshift([Time.now,note_text])
  end

  
  def to_s
    "hello I'm a project"
  end
end

## manual testing
test = Project.new("test project","tp","personal")
test.add_note("called john")
test.add_note("called john2")
test.add_note("called john3")
#puts test.notes
p test.notes
if test.title == "test project"
  puts "ok"
else
  "not ok"
end 
test.title = "new title"
puts test.title



class Task
end

#class generic-project-task
#end

#m = YAML.load(File.read('yaml.dump'))
# m = File.open('/marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

#m = [1, 2, 3, 4, "Ruby"]

#sleep 0.9

#File.open('yaml.dump', 'w') { |f| f.write(YAML.dump(test)) }
#File.open('marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

#====='

=begin

;;;;;for 5/19
;;;;; work out how to have add-note work without pass by referenc, or figure out how to do that
;;;;; test update property once add note works

;;; pass by referenc would solve this too
(define (add-note note-contents notes-list)
  ;; There is no such thing as update-note; notes are immutable.
  ;; pushing to 0 breaks assoc list -NEM
  (push
    (list (date-value) "contents of note") notes-list 1) 
;;   task-or-project)



;; ;;; TODO this will work great, except maybe need to use a replace to update the project or task passed in?
;; (define (add-note task-or-project)
;;   ;; There is no such thing as update-note; notes are immutable.
;;   ;; pushing to 0 breaks assoc list -NEM
;;   (push
;;    (list (date-value) "contents of note") (assoc 'notes task-or-project) 1) 
;;   task-or-project)

;; Updates projects-and-tasks global directly.
(define (create-task! title-param action-context-param)
  ;; required: title-param, action-context-param.
  ;; Creates a task with the given title-param.
  ;; Also adds the task to the data structure.
  (setq task (create-task-or-project title-param))
  ;; Add task-specific metadata.
  (push (list 'action-context action-context-param) task 2)
  ;; Push to the database.
  (push task projects-and-tasks))


(define (create-task-or-project title-param)
  ;; required: title-param
  (setq uid (setq latest-uid (+ 1 latest-uid)))
  (setq task-or-project
	(list
	  uid
	  (list 'title title-param)
	  (list 'creation (date-value)) ; date-value defaults to now
	  (list 'modified (date-value))
	  (list 'last-reviewed (date-value))
	  (list 'completed nil)
	  (list 'deleted nil)
	  (list 'notes (list (date-value) (format "Created: %s" title-param)))))
  task-or-project)
 

;; testing
(push (create-task-or-project "testing title") projects-and-tasks)


;; testing
(println projects-and-tasks)
; commented to keep from spamming savefile
;(save savefile-filename 'projects-and-tasks 'latest-uid)

;(exit)



;;; AWESOME SPEC HERE. READ THIS.
;; so to recap.
;; projects contain tasks.
;;   projects cannot contain further projects (no subprojects)
;;     if you need to group a set of projects together, tag them.
;; tasks cannot contain other tasks (no subtasks)
;;   note to self, if you think they should, then try creating more projects
;;      else break it down more & CLARIFY your thinking
;; tasks can exist independent of projects
;;   if you have a single action that isn't tied to a multi-step desired outcome ('project')
;; projects must have at least one task/next action defined.
;;   if not the system will remind you
;; projects can have more than one task/next action defined.

;; projects have this metadata, in addition to containing tasks:
;;x projects must have a single--unique--keyword, for rapid access
;;x    This is used to uniquely address the project rapidly from the command line.
;;x  projects are grouped by area of life (work, personal, home/family, business)
;;    "life contexts", for separation of work/personal life.
;;     I don't want to see my work tasks after 5p, or my coworkers to see that smutty romance I'm writing after work.
;;x   projects are also grouped by tags
;;     form is #tag or #anothertag or #another-tag
;;x       tasks do NOT have tags, only action context (not to be confused w/ life context).
;;x   projects have a project support material section.
;;     when viewing a task you see title, date metadata, action context, and most recent note. and has a history of note/title/reviewed changes.
;;     when viewing a project you see everything a task has,
;;     including most recent note,
;;     AND you see a static few lines of project support material (psm)
;;       that can be edited at any time.
;;       [this is to solve the 'project info at bottom of notes list in RTM' problem]

;; projects AND tasks have this metadata:
;;x   task or project title (the actual name of the project or what the task actually is haha)
;;x   creation timestamp 
;;x   completion timestamp ;; active means no completed timestamp, no deletion timestamp. completed means completed timestamp and not deleted timestamp.
;;x   deletion timestamp ;; deleted means deleted time stamp is present
;;x   last-reviewed timestamp
;;x    notes, each with a timestamp
;;      title changes = new note pushed
;; at minimum, each project and task has a history of changes ('log')
;;   and each project and task has a history of notes, with the most recent one always displayed for quick status check
;; although ideally a glance through the color-coded tasks on a project gives you the status, but if you want more you can delve in.


;; in addition projects track this metadata in the log
;;   added/removed/completed/deleted task = new note pushed

;; in addition, tasks only track this metadata
;;x   <action context> what do I need to do this? my work computer? my personal computer? errands/car/bike? home w/ mower etc.




=end
