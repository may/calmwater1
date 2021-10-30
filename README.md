<!---
Created: 2020-05-30
Revised: 2021-10-28
--->

## extbrain: a fast, command-line, GTD tool that holds you to account

## Requirements:
   * ruby 2.6.3 or greater

## Reccommended, but entirely optional:
   * tput (if you don't have this set $color_only to false in config.rb)
     * `apt install libncurses5` on debian/ubuntu, otherwise see: [tput](https://command-not-found.com/tput)
   * [rlwrap](https://command-not-found.com/rlwrap)

## Install

   0. Software is still under active development and I forgot to use a branch, so likely broken. (10/26/2021)
   1. [Download](https://github.com/may/extbrain/archive/refs/heads/trunk.zip).
   2. Open a terminal and unzip extbrain-trunk.zip, presumably in your Downloads folder.
   3. ```ruby Downloads/extbrain-trunk/main.rb```
   
## Using:
   * ```rlwrap ruby main.rb```
   * or, if on Windows: ```ruby main.rb```

## TODO design principles

   * Never lose data. 
   * Never lock you in; your data is yours and human-readable.
   * Fast; capture your thoughts, update your status, etc. -- quickly.
   * Stays out of your way, but keeps your data at you fingerprints.
   * Pure GTD; no tweaks or additions like priorities. No cruft.
   * Supports habit tracking? (But not part of GTD core functionality)

## TODO the rest of this README

      

# won't work under windows
- color coding of output
- opening a second instance of extbrain on the same machine (eg server) will just exit, instead of gracefully shutting down the first process

# todo some documentation

# HABITS
h - to list habits
h foo - to complete foo for the day
h foo yesterday - to complete foo for yesterday
h wc - to create a word count habit
h wc 500 - to complete the word count goal for today, with a total word count of 500 for the document (the software will calculate today's word count)
h keyword delete - delete a habit

# PROJECTS
p keyword string - creates project with keyword and title of string
pt keyword action_context string - creates a task within project specified by keyword with specified title of string with action context of action_context

# TASKS
t - lists tasks
t work - list tasks in work action context
t work call bob re: proposal - create task in work action context with the contents of 'call bob re: proposal'

when creating tasks, can use abbrevations for action contexts such as 'c' for computer, 'w' for waiting, and 's' or 's/m' or 'm' etc. for someday/maybe


use 't action_context' to list tasks in a given action context, like 't computer' or 't job'
shortcuts available: lc and lj 

in general hitting ENTER on a prompt will do nothing and allow you to exit out of that prompt, such as when selecting tasks

in general, the undo command is available for some actions such as completion, deletion and other serious actions


# ADVANCED
w what you are waiting on
w  (no arguments, works like lw)
w <one word search> - eg 'w bob' - show everything I'm waiting on Bob to do.

context <contextname> - change from job to personal context or other defined context. cd <contextname> also works



# Testing
rake test
test coverage for some underlying data structures, but not for middleware






# TODO VET THIS STUFF LATER


alias extbrain='rlwrap ruby ~/extbrain/main.rb' 


# COMMAND STRUCTURE

## OTHER
s search_keyword - look for keyword, else search all titles for search_keyword, across projects and tasks
#f - add a note that followed up with person we're waiting on
##aw - swap a task from action to waiting or vice versa?

## TASKS AND PROJECTS
c search_keyword - complete task matching search keyword/list tasks 
d search_keyword - complete task matching search keyword/list tasks 
n - nottaking TODO FLESHOUT.
r search_keyword - rename/retitle task or project specified


## TASKS
When a search_keyword is used, the action will be taken on the single
task matching that search, or -- if there are multiple matches --
present a list of options matching that search and have the user choose
using numbers - or running a more refined search again from the prompt.
##d 5 - delete the 5th item just displayed? if only.

w - display waiting task list
a - display agenda list
a name - display agenda list for name
a name content - create agenda item for name [note: task w/ action context fo a person]
t - list all tasks
t action_context - list all tasks in a given action context, otherwise use this shorthand
 tc - list all tasks computer action context
 th - " " home
 tw - " " work
 tj - aliaso for tw, j for job

#TODO tasks.filter once ruby = 2.6.3 or just live with select nomeclatre
t = @tasks.select { |t| p.action_context == action_context  
t.each { |t| puts t }
printing some kind of short uid instead of a custom numbered menu might be easier.. less state to manage..



## PROJECTS
p or lp - list projects for the current or given life context
p all - list all projects regardless of life context
p keyword - view project with keyword
p keyword title - create project with keyword and title 
tag keyword - add tags to project?
pt keyword action_context task - add a task to project with keyword in action_context with a title of task #pt stands for project task
## HABITS
xh - list habits
xh keyword - log habit for today
xh keyword title - create new habit with keyword and title



---

If your delete key does not work, try this:

.inputrc
  "\e[3~": delete-char


----

notes:
 review projects and tasks every 5-7 days
 review areas of focus/resp every 30 days.
