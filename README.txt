Created: 2020-05-30
Revised: 2020-06-19

Requirements:
 ruby

Optional:
 rlwrap

Using:
 rlwrap ruby main.rb


todo some documentation
h - to list habits
h foo - to complete foo for the day
h foo yesterday - to complete foo for yesterday
h wc - to create a word count habit
h wc 500 - to complete the word count goal for today, with a total word count of 500 for the document (the software will calculate today's word count)

alias extbrain='rlwrap ruby ~/Dropbox/scripts/extbrain-dev/main.rb' 


# COMMAND STRUCTURE

## OTHER
lc - display current life context and available options (searches all projects and makes list of life contexts)
        @projects.unique { |p| p.life_context }    
lc life_context - set current life context globally, such as work home etc.
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
p [optional: life_context] or lp - list projects for the current or given life context
p all - list all projects regardless of life context
p keyword - view project with keyword
p keyword title - create project with keyword and title 
tag keyword - add tags to project?
plc keyword life_context - edit life context (home, work, etc.)
pt keyword action_context task - add a task to project with keyword in action_context with a title of task #pt stands for project task
## HABITS
xh - list habits
xh keyword - log habit for today
xh keyword title - create new habit with keyword and title


