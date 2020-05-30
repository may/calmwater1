;; Created: 2020-05-13
;; Revised: 2020-05-30
;; Copyright: Nicholas E. May. All rights reserved.



# NOW

finishing project implementaiton in ruby
implementing tasks in ruby

MAYBE

!! is writing mode
just keeps acecpt ing text line by line
until !!
and saves it to idsk each time inc ase of ctrl-c if caught writing at work


.finishing design goals in blog post before writing software?
MAYBE.process all the subtasks in rtm for this project to see if any other features needed to be accounted for in data sturcture

todo - document that if you don't specify a life context it will default to personal.

syntax todo - // for note right away ala rtm

command for, when you're in a project completing a task, add a note to the project. or maybe that will just be easy and fast, but it's a common operation.

=====stats====
tl;dr save # of projects per life context, each day the app is run. also #tasks. Also #s/m. retrive via 'stats' command. and save in the 'stats' variable, saved seprately.
=====

stats page showing at least:

trending up or down
average # tasks & avg # projects

# tasks
# projects, work
# projects, personal
# projoects, home
# projects, sideproject
# projects, sideproject2
# projects: total

MAYBE# tasks (# tasks 3 days ago, 7 days ago, 1 month ago, etc.)
MAYBE# projects (#projects 3 days ago, 7 days ago, 1 month ago, etc.)
======/stats========

when using lp to display a project, should show 'other projects with this tag' in easy numbered list to select, with keywodrs eg:
1. (upgradebs) bullshit around upgrade b/c foundations didn't communicate
2. (upgradebca) some bullshit I should do about bca web meh


tickler support for due dates.
prompt will change from > to 6> where 6 is the number of items due today
entering t (for tickler or today) will show the list of everything for today and this week (m->sund)
consider ti or tick or tod if t is taken

also build a function where you can toggle between waiting and next action. ideally the default next action contexnt for that life context. eg hcis/work conetxt -> hcis computer list, home is home list etc. that way it's faster. and of course push all those changes to the history log for that task. also, if needed, consider defining a toggle context for each task eg explicitly saying waiting to compuer list or waiting to nick's office etc.

add a note to the documentation/blog that users should save the savefile in a cloud-backed-up directory like dropbox or have a regular backup of their computer.

p
load data on startup.
 on save:
  0. check if lockfile exists, if so wait 1 sec, try again, repeat for 65 seconds, then fail.
  1. lock savefile & set a variable that we have it locked
  2. load data from disk & parse
  3. add changes (added task, edited etc.) to data structure
  4. save data to disk
  5. unlock savefile & unset variable that we have it locked



# UPCOMING

PRINTING of dates should be handled with DST accounted for
after march 8
nov 1

lt = list today's dues?

'adt' shuold show all tasks added today

### view history / log
of both notes
and communications




## viewing task lists

> extbrain
> Displays your work tasks:
>> lw / or configured must be more than one character, maybe w allowed?
> Displays your home tasks:
>> lh / or configured must be more than one character, maybe h allowed? 
> Displays your computer tasks:
>> lc / or configured must be more than one character; c is complete
> Displays your freelance computer tasks:
>> lfc / or configured must be more than one character; c is complete

## viewing groups of project by context/tag

> extbrain
> Displays your personal projects (those not tagged w/ anything)
>> lpp
> Displays your work projects:
>> lpw / or lphcis etc.
> Displays your home projects:
>> lph 
> Displays your freelance projects:
>> lpf
> Displays all projects:
>> lp
> Displays all tasks in project *keyword*:
>> lp *keyword*

## viewing info about projects or task
> viewing metadata or info
>> lm *keyword* search - eg lm amazing billy - all tasks in the amazing projcet w/ billy in them
>> li *keyword* same li or lm same

# renaming rename

> extbrain
>> r keyword new title for project keyword
or 
> extbrain
>> r keyword
> current title: current title for project keyword
> enter new title:
>> new title for project keyword
> new title saved, keyword unchanged.

# rekeying
> extbrain
> rk keyword newkeyword

# adding notes to a project
> extbrain
>> n keyword
> enter your notes for project: project name
>> this is a brief note, billy is late with the project, pinged him

# adding notes to a task
> extbrain
>> n keyword billy
> enter your notes for task: billy send me notes
>> this is a brief note, billy is late with the notes, pinged him AND his boss

If the system can't find a unique task, the standard logic appllies; display all task, choose via keyword or number until the set is reduced to one task.


# adding long notes to a task
> extbrain
>> nn keyword billy
> enter your notes for task: billy send me notes
>> this is a long note
>> billy is late with the notes
>> pinged him AND his boss
>> we need this by friday
>> I cank eep doing this
>> even a blank line
>> 
>> until I type nn
>> nn on it's own line
>> nn!



# viewing log fo a project's changes

** todo decide l for log and lp for list project, vs. log for log and l for list project or task?** 

> extbrain
>> l keyword 
> project created: 2020-...
> title changed: 2020...
> etc.

>> lr keyword
reverse chrono listing



### Quickly add/remove/delete tasks by keyword or number on a given project.

> extbrain
>> lp keyword
> project (keyword): example project
> work: research for sally, email her back

> extbrain 
>> c keyword sally
> completed task: work: research for sally, email her back
>> c keyword billy
>  found:  
>  1. waiting: Billy to finish the audit
>  2. waiting: Billy to send me notes from the last meeting
>> audit
> completed (purple}: waiting: Billy to finish the audit

OR you could: 
>> c keyword billy
>  found:  
>  1. waiting: Billy to finish the audit
>  2. waiting: Billy to send me notes from the last meeting
>> 1
> completed (purple}: waiting: Billy to finish the audit



### Viewing projects
Welcome to extbrain, version 0.00 ("design").
> lp keyword [could p work too?]
 project (keyword): example project
1. work: research for sally, email her back
2. work: finish the spreadsheet
3. agenda: talk to boss about X  
4. waiting: Jim to get me quote for new equipment
5. waiting: Robert to requset access
6. waiting: Billy to finish the audit
7. waiting: Billy to send me notes from the last meeting
8. waiting: John send me copy of the last audit
9. latest note: <  some text here >
10. project support material <text here >
which also displays all actions, agendas, and waitings in that order. 
(action list red, agenda blue, waiting green, keyword is yellow; each section sorted oldest to newest)
space or enter for more, or enter a number or a partial string ('robert') to select a task for viewing
or say c robert or c 5 to mark it complete
ditto d robert or d 5 to mark it deleted
e robert or e 5 to open it for editing
n robert or n 5 to add a note
when a task is open, c completes, d deletes, e edits, n adds note
c without a search or a number to complete the project
d without a search or a number to delete the project
e without a search or a number to edit the project
n without a search or a number to add a note the project
psm without a search or a number to view/edit the project Support material text
l to see the reverse chronological log of all changes, including notes

you can also, from the default command line
c keyword to complete the project
d keyword to delete the project
e keyword to edit the project
n keyword to add a note to the project
psm keyword to view/edit the project Support material text
l keyword to see the reverse chronological log of all changes, including notes

> [yellow keyword] [RED] project deleted :[/RED] ....
> [yellow keyword] [GREEN] project completed [/GREEN]: .... 

you can also, from the default command line
search for a project/task [if you can't remember project keyword], if one found, takes action, 
 else prompts user repeatedly with a list of matching projects/tasks to select from
  user can use number keys or a unique search string to narrow result set down repeatdly
   until only one is found, then action is taken
c string to complete the project/task
d string to delete the project/task
e string to edit the project/task
n string to add a note to the project/task
v string view the project/task
psm string to find a project, then view/edit the project Support material text




lc keyword/action-context-or-agenda-or-waiting - list completed tasks by project keyword or list
    note only shows 7 days if non-project
ld keyword/action-context-or-agenda-or-waiting - list deleted tasks by project keyword or list
    note only shows 7 days if non-project

when adding a project or modifying a keyword, ensure that keyword is unique, else reject.

support lp #upgrade to narrow projects list to just a tag

support short tags for common lists/stauses AND support full tags:
#w = #waiting = #wait
#a = #agenda = #ag
#c = #computer = #pc
#j = #job = #job-computer


Query list of projects:
> p OR lp OR list projects OR MAYBE list-projects OR MAYBE just lp;; lp if it's just me, list-projects for learners not me

List projects in work context (can also be called dayjob, companyname etc.)
> p or lp etc. work 
> p work
> lp work
> list-projects work


Show me the upgrade project.
> p upgrade





creating a project:
> the upgrade project (january 2021). #p #upgrade 
(if no keyword, prompt)
> what keyword?
> > upgrade
>thank you

creating a task:
> this is a project task #keyword #action-context-list-agenda-person-or-waiting 
> this is a non-project task #action-context-list-agenda-person-or-waiting #nop
  [implies action context lists have reserved names that project keywords can't take like work, home, computer, errands etc., which gets dicey when you have a 'new computer' project w/ keyword computer... maybe just c for computer?]
  [system defaults to assuming tasks go with projects, and doesn't want them to get decoupled by accident, so if you really want to add a task without a keyword, the system needs to have you say #noproject or #nop for short]
  [if you don't include a keyword, system will prompt you to add a keyword or #nop]

adding an idea, or a quick task (i.e. too quick to organize properly), goes into inbox
> text [no keyword, no project, no nop, just text]


n keyword text - add text note to project with keyword. if keyword isn't found, search for that, prompt user to select from list of results (further search string or by number).
 then enter note mode until told to stop (nn!)
   note that status updates on waiting tasks contained in projects may be better to go on the project itself (since projcets are smaller now)


TODO nottaking mode.
> n
n> every line
n> you type
n> is entered into a new note and placed in your inbox
n> unless you invoked with "n <keyword>" then it is assigned to thaht project
n> and the prompetd changes you may notice
n> and teh prompt conitunes and data is saved everytime you hit enter
n> untile you say NN!
> then we return to normal
TODO consider also if [] is embedded in note that's a task, if a keyword can be found it will be added to that project ,else it will be added as a taksk to inbox





c for completion?
dt for deletion??
uc for undo completino? prints list of all completed tasks, most recent first
ud for undo deletion? prints list of all deleted tasks, most recent first
uca "" but go to the achive file year-completed
uda "" but go to the delete file year-deleted
if you have to go back more thana  year we can make that happen in like v3.. uca year ... uda year...

completed task = set the status to deleted, and the completed timestamp

deleted task = set the status to deleted, and the deleted timestamp

at the end of every weekly review, or when idle for 35 minutes, do garbage collection (7 days means we'll be off by 7 days whenever the year rolls over, but oh well,timestamps still exist):
 print "Beginning housekeeping...archiving deleted..."
 load file extbrain-data/year-deleted
 any *non-project* task or project with the status deleted, and deleted-timestamp > 7 days, move to year-deleted data structure
 save file extbrain-data/year-deleted
 save file extbrain-data/extbrain-data
 println "deleted archived."
 print "Beginning housekeeping...archiving completed..."
 load file extbrain-data/year-completed
 any **non-project task** or project with the status completed, and completed-timestamp > 7 days, move to year-completed data structure
 save file extbrain-data/year-completed
 save file extbrain-data/extbrain-data
 print "completed archived."
[completed tasks within a project should stay with that project until the whole project is archived as a whole]

r command = review, which no only sets last-reviewed timestamp, but also puts a entery in the log (not sure about log entry but think it'd be cool)

consider instead of a 'v' (for 'view') syntax, why not simply type a project's keyword and view it that way?

can also select projects by number from list-project for viewing



search
global as usual
s <keyword>
but also within a task or project
. foo or consider t for task or p for project instead of . 
and history fo notes etc. 




## dynamic lists
If you've used RTM, you're used to the concept of *smartlists*

we want to quickly generate the following kinds of lists on the fly:
agendas for wife (everything tagged agenda or waiting with Nicole in it)
agendas for boss (everything tagged agenda or waiting with Paul in it)
agendas for vendor support (... with Mike in it etc.)
projects personal
projects work
projects freelance
tasks @ work computer
tasks @ personal computer
tasks @ home
tasks @ errands
waiting 
review waiting
review s/m
review action lists for completed (ideally lists by context, work, personal, etc.)
etc. 

## review lists/weekly review stepthrough!! inc the 5 oldest s/m and the 5 oldest tasks 

weekly review also asks you about the oldest (last-reviewed timestamp) of areas of focus/resp to make sure that's up-to-date and still relevent


a mechanism to spacebar through each project, task action, and old s/m and old task to indicaet it's been viwed. ! to undo last, repeatedly etc.
^ yes this as part of the review module. review thing.
just hit review and good to go. or weekly-review. or wr. 

## list keywords

> extbrain design
>> lk
> your keywords are: apple, bannna, pear, etc. 
>> lp
>> p1 projects in current context (work, not-work), sorted by last updated etc. 
>> p2 ... 
>> p3... 
>> p4.. 

## todo integrate priority, now, soon, upcoming as ways to slice project list, where anything that isn't priority or now is upcoming/soon?

## todo reschedle task
## todo reschedle/delay/postpone task WITH note
## todo due dates
## todo notes? or is that done?
## todo rueferenec pull and push, eg probably by keyiword query
## todo tickler


# todo config options
hide work from lp from 5p-8a.





## Tech questions
flat files, searilaziton or read in out?
see what ruby/newlisp have to offer. 
I'd be ok with
project
 x. completed task
 open task
 jon - open task #waiting
 sally - open task #agenda


will support 
 v <project> 
  shows metadata about project, including the most recent note (or two?)
will support
 defined areas of focus in your life
  work, personal, home/family, business
   each can be named
    eg work ("HCIS @ UIHC")
       personal ("Nick's projects")
       home/family ("Nick & Sarah's Happy Married Life Together")
       businenss ("Nick's freelancing; $200/mo+)
  and each has at least one context
       work - hcis
       personal - computer (personal computer)
       home/family - house/lucas-st 
       freelance - fc / freelance computer
       
todo how do you view all tasks in a given context?
l work
l pers
l home or l fam or l family
l biz or l business or l bis or l freel or l fc

        




# FUTURE

Consider, if multipule projects or tasks are returned, pressing enter to cycle through them, backspace to go back one. if that's easy to code. constant readline loop?
also display projects in this context without keywords,
then projcets in toher contextts w/o keywords





### v2 System prompts to keep your lists up-to-date whenever you add a task

If you add a *type* of task to a project denoted by *keyword*, extbrain will prompt you with a list of other tasks on that same project *keyword*, of that same *type*. And ask if you if any can be completed. TODO Bonus - anything added recently surfaced first. so if you're actively back and forth with someone...

The idea here is if you're adding a waiting task, perhaps you've received something you were waiting for and it can be crossed off.

### quickly grab the thing you just created or edited (most recent edit/creation timestamp):
!  - opens most recent creation or edit for viewing and then you can edit
!!  - opens second most recent creation or edit for viewing and then you can edit
 (sort the list, (first) or (second) haha


### Search for projects/tasks/notes/reference in that order of gradually increasing scope
     > s foo
     > s foo #keyword???

     so it will return:
     1. projects with foo in the title
     2. tasks with the word foo in the title
     3. notes with foo in the body
     4. reference with foo in the body

     making you hit enter or space to advenc to from 1 to 2 to 3 to 4 unless nothing for 1 then it will just show 2 etc.

     If you had these three tasks: 

     > waiting: Billy to finish the audit
     > waiting: Billy to send me notes from the last meeting
     > waiting: John send me copy of the last audit

     And you chose either Billy or audit as your search word

     the system would let you decide between those duplicates with 1/2 or keyword 

     and this recursion would continue until there was only one optino if you kept keyword searching

     **if the results you got back aren't what you wanted, you could search again**

     if you asked for audit
     and meant compliance

     just type compliance and if there are no hits, it will re-search in your previous context (eg project or higher). 
/SEARCH-SPEC


# MAYBE

publish this code as a .zip on pcloud and link to it from my blog. no need to publish code history or fuck w/ github. once this hits 1.0 or maybe 2.0
maybe a static page from my blog!! download/install newlisp, then this and then go.

handle parsing of a defined set of people so you just type in "ask nata about joe" and it will find 'nata' and add the task to the agenda list, unless it also finds a defined keyword in there.

adding to tasks is much harder by design, implement later
  you have to go find the task and then add a note to it
  unless you're creating it, then you just tack it on there with //
   maybe some extended form of 'adding a task' now enter note mode..
 or instead of n keyword if keyword isn't found it searches for that, gives you list of results and then 


;; question, when one project is waiting on another, instead of a
;;   project -> task pair
;; could we instead have a
;;   project -> pointing to project as it's waiting task instead of a separate (duplicated) task?


think about on-the-go mobile access/gpd pocket/webaccess/small laptop withyou
 or just paper/printout from my laser printer..

think about using newlisp javascript to run this local in browser?

newlisp logging mode enabled by default during dev/even when running in prod to help enchance 'don't lose data'.

anything in inbox w/ creation >7 days counts against you in the scoring haha

## v3 todo have it output projects now, projects upcoming (sorted order?), and future. then copy paste into one note weekly! 
^ not sure tracking projects upcoming, but maybe if I am then yes this would be useful instead of managing myself in both my system and in fracking onenote for my boss. supports being strategic with my boss.

=========================================================================
If the app gets slow due to I/O or parsing data structures, review this:
While writing this spec 2020-05-15 I just don't have enough data to know if this will be a problem, so wrote down thoughts and went on
2020-05-15, #2 - I just loaded and saved the entire text of hamlet in less than a tenth of a second on my shitty blue laptop. so I doubt loading/saving will be a file, at least not compared to Ruby. We'll see once ther is more parsing though. Hamlet is 196K.
=======================
load data on startup.
 on save:
  0. check if lockfile exists, if so wait 1 sec, try again, repeat for 65 seconds, then fail.
  1. lock savefile & set a variable that we have it locked
  2. load data from disk & parse
  3. add changes (added task, edited etc.) to data structure
  4. save data to disk
  5. unlock savefile & unset variable that we have it locked
If this loading, and parsing slows us down too much, do this instead.
  1. lock savefile, and keep it locked for 5 minutes (if the user is making edits, changes are they're going to keep doing it)
If that's not enough, extend it to 20 minutes.
If that's not enough, get fancier with hashing the structure and checking that hash.
If that's not enough, make whomever starts up first get the lock, and everyone else (all other instances) read-only.
If that's not enough try the below, otherwise look into saving new info/queued edits to another file and merging w/ database when the system is idle?
Or, even better, save to big data structure, but don't save that to disk; instead just append the change to a small temoprary file that ill exist if we crash. not great, but possibly fast.



If extbrain loads data on startup and doesn't reload perodically
and another instance starts up, modifies the database, and shuts down again,
that could be problematic. (eg we save our older version of the database over that file and we lose info from other copy).
so do we:
 1. force all but one running version to be read-only?
 2. sacrifice speed for data integrity, and reload the database before saving a task?
 3. reload the database whenever we see the file changes, but only if it's changed?
 4. hash the database and save that hash in the database so we can detect if it's changed?
 5. if we don't have database lock, save to other file then the process that does have the database locked, can pickup that file and integrate that task/project/note etc?

I'm thinking #2 + #3/4; conditionally load database if it's changed (not by us).


==================


csv command to dump everything to a csv? I did complain about lack of this with RTM before writing this software, so it's only fair... (of course if software is private then whatever)


# MAYBE NOT/HELL NO.
See devlog.txt for details. Add new at top.


- no: automatic detection of agenda people. yes: user defined agendas
- non-unique keywords
- projects contain tasks. no subprojects. no subtasks. flat structure.
- no project status calculated from state of associated/contained tasks
