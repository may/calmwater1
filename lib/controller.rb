# Created: 2020-05-30
# Revised: 2021-11-13
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'

def add_or_list_someday_maybe(keyword, content)
  if keyword and content
    puts $data.new_somedaymaybe(keyword + ' ' + content)
  elsif keyword
    results = $data.search_someday_maybe(keyword)
    if results.empty?
      puts 'No results found; no someday/maybe with that search term.'
    else
      results.each { |sm| puts sm }
    end
  else
    # no keyword to narrow selection; list everything
    $data.somedaymaybe.each { |sm| puts sm }
  end
end

def view_or_add_task(action_context, keyword, content)
  if keyword and content
    task_input(action_context, keyword + ' ' + content)
  elsif keyword
  # task_input(action_context, keyword)
    task_list(action_context, keyword) # can no longer add one-word tasks
    ## 2020-12-10 ^ it would be nice to have one word tasks, but honestly I only
    ## use them for testing. A one word task in the real world isn't sufficently
    ## actionable.
  else
    task_list(action_context)
  end
end

def take_edit_action(action_verb, object_to_operate_on)
  if object_to_operate_on # check for nil
    case action_verb
    when 'add_note'
      add_note(object_to_operate_on)
    when 'complete'
      complete_task_or_project(object_to_operate_on)
    when 'delete'
      delete_task_or_project(object_to_operate_on)
    when 'edit_psm'
      edit_psm(object_to_operate_on)
    when 'rename'
      edit_title(object_to_operate_on)
    end
  else
    puts "No action taken."
  end # if object_to_operate_on
end

# action_verb should be one of:
#  'add_note'
#  'complete'
#  'delete'
#  'edit_psm'
#  'rename'
def edit_project_or_task(action_verb, keyword, content, projects_only = nil)
  unless keyword
    puts "Need to specify which task or project in order to #{action_verb}."
    puts "For a project, specify a keyword or type a seach term. "
    puts "For tasks, just type a search term."
    puts "Multi-word searching is supported. TODO."
  else
    object_to_operate_on = nil
    results = $data.search(keyword, content, projects_only)
    if results.empty?
      puts "No results found for query."
    else
      if results.count == 1
        object_to_operate_on = results.first # it's an array of one item, hence the .first
      elsif results.count > 1
        puts 'More than one project or task matched search critera.'
        puts 'Choose an item by entering a number. Press ENTER (without input) to exit without changes.'
        results.each_with_index do
          |project,index|
          print index+1 # make the list start at 1 for the user
          print '. ' 
          puts project
        end
        print '>> '
        number = gets.strip
        unless number.empty?
          # convert from what we showed user to what we have internally
          index_to_use = number.to_i-1
          object_to_operate_on = results[index_to_use]
        end
      end # results 1
      take_edit_action(action_verb, object_to_operate_on)
    end # results.empty?
  end # unless keyword
end # def
  


# TASKS

def task_list(action_context = nil, keyword = nil)
  if keyword and action_context
    $data.list_tasks(action_context, keyword)
  elsif action_context
    $data.list_tasks(action_context)
  else
    $data.list_tasks
  end
end
  
def task_input(task_action_context,task_body)
  if task_action_context
    if task_body
      puts $data.new_task(task_body,task_action_context)
    else
      task_list(task_action_context)
    end
  else
    task_list
  end
  # t action_context description_of_action_that_needs_to_be_taken
  # t computer email bob re: request for widgets
  # t house get the ladder from the garage, grab the hose and clean the gutters
  # t foo = create task w/ content foo
  # pt is how you create a project task
  # ^todo make this print whenever you have less than 10 tasks
end

# SOME EDITING FUNCTIONS
# For now, when renaming, we will just print the existing title first,
# and encourage the user to re-type the content.
# 
# It is possible to pre-populate the user's text field with the existing title or content
# but that is a bit messy, and we'd like to strongly encourage the user to think
# and clearly define, for example, what the desired outcome is *now*,
# instead of just adding more text to what's already there.
# I have totally been guilty of that in the past.



def add_note(project_or_task)
  print 'Add note to project or task: '
  puts project_or_task.title
  puts "Keep typing your note and pressing Enter. Say 'done' when complete."
  note_so_far = String.new
  print '>> '
  until (note = gets.strip) == 'done'
    note_so_far << note + "\n"
    print '>> '
  end 
  if note_so_far.empty?
    puts 'No note added.'
  else
    project_or_task.add_note(note_so_far)
    puts "Note added:"
    puts project_or_task.notes.first
  end
end

def edit_title(project_or_task)
  print 'Current title: '
  puts project_or_task.title
  print 'Enter new title: '
  new_title = gets.strip
  if new_title.empty?
    puts 'Title unchanged.'
  else
    project_or_task.title = new_title
    puts "Updated title: #{project_or_task.title}"
  end
end

def edit_psm(project)
  puts 'Current project support material:'
  print ' ' 
  puts project.psm
  puts 'Enter new project support material/summary: '
  new_psm = gets.strip
  if new_psm.empty?
    puts 'PSM/summary unchanged.'
  else
    project.psm = new_psm
    puts "Updated project support material/summary: #{project.psm}"
  end
end

def delete_task_or_project(object)
  $undo = [object,'undelete']
  object.delete
  puts "Deleted #{object.class}: #{object}."
  puts "Undo available if needed."
end

def complete_task_or_project(object)
  $undo = [object,'uncomplete']
  object.complete
  puts "Completed #{object.class}: #{object}."
  puts "Undo available if needed."
end

def project_keyword(keyword, new_keyword)
  if keyword.nil? or new_keyword.nil?
    puts "Proper usage: pk keyword new_keyword"
  else
    if p = $data.project_exist?(keyword)
      # TODO I should fix this, see project.rb/add_task
      puts "NOTE THIS WILL BREAK THE *DISPLAY* LINKAGE BETWEEN EXISTING PROJECT TASKS" 
      puts "Are you sure? (y/n)"
      if gets.strip == 'y'
        p.keyword = new_keyword.to_sym
        puts "Changed keyword."
      else
        puts "No action taken"
      end 
    else
      puts "No project found with keyword: #{keyword}. Unable to update keyword."
    end
  end
end

### PROJECTS

def find_and_show_project(keyword, show_notes = false)
  if p = $data.project_exist?(keyword)
    if show_notes
      p.view_project_and_notes
    else
      p.view_project
    end 
  else
    puts "No project found for keyword #{keyword}"
  end
end 



def project_task(keyword, content)
  # pt keyword action_context some text about my task - adds a new task 'some text about my task' to the project specified by keyword, or errors of no keyword found
  if keyword.nil? or content.nil?
    puts "Must specify a keyword and more."
    puts "Proper usage: pt keyword action_context the title of your task"
  else
    if p = $data.project_exist?(keyword)
      two_pieces = content.split(' ', 2)
      action_context = two_pieces[0]
      title = two_pieces[1]
      puts p.add_task(title, action_context)
    else
      puts "No project found with keyword: #{keyword}. Unable to add task."
    end
  end #nil?
end 

def project_input(keyword, content)
  # p or lp - list projects
  # p keyword - view project with keyword
  # p keyword title - create project with keyword and title 

  # 'p' or 'lp' etc : view all projects, unless context specified
  # TODO MAYBE or tag specified
  ## ^^ INSTEAD consider GROUPING by TAGS
  ## ^^^ SORT TBD; probably just order projects created in
  # 'p keyword some project' # creates some project w/ keyword of keyword
  if keyword
    if content
      if $data.new_project(content, keyword)
        print "Project created: "
        puts $data.project_exist?(keyword)
        if $data.projects.count < 10 # todo ideally have proper accessor for # of projects
        end
      end
    else # just a project keyword
      find_and_show_project(keyword)
    end
  else # no keyword or content
    $data.list_projects
  end #keyword
end # def

def move_someday_maybe(keyword)
  if keyword
    $data.move_someday_maybe(keyword)
  else
    puts "Need to specify a keyword."
  end
end

def search(keyword, content)
  if keyword
    results = $data.search(keyword, content)
    if results.empty?
      puts "No results found for query: #{keyword} #{content}"
    else
      results.each { |p_or_t| puts p_or_t }
    end 
  else
    puts 'Empty query. Try again.'
  end
end

def search_someday_maybe(keyword, content)
  if keyword
    results = $data.search_someday_maybe(keyword, content)
    if results.empty?
      puts "No results found for query: #{keyword} #{content}"
    else
      results.each { |sm| puts sm }
    end
  else
    puts 'Empty query. Try again.'
  end
end

# todo if project, allow adding pt
# else allow t at any time
def review_and_maybe_edit(object, associated_project = nil)
  def project_task_maybe(object, action_context, keyword, content)
    if object.is_a?(Project)
      puts object.add_task(keyword + ' ' + content, action_context)
    else
      puts "Error: can't add a project waiting task to something that isn't a Project."
      review_and_maybe_edit(object)
    end 
  end #project_task_maybe

  action_verb = nil
  if RUBY_PLATFORM.include?('mingw') # windows 10 via rubyinstaller
    30.times do puts end
  else
    system('clear')
  end

  if object.is_a? Project
    print '      Project: '  
  else
    if associated_project
      puts "Project: #{associated_project}"
    end
    print '        Task: '
  end
  puts object
  print '>> '
  input_string = gets.rstrip!
  three_pieces = input_string.split(' ',3)
  command = three_pieces[0]
  keyword = three_pieces[1]
  content = three_pieces[2]
  
  # ENTER or space to go to next item, eg return from this function, after setting reviewed date
  if command.nil?
    object.reviewed
    if object.is_a?(Project)
      puts "    Project (#{object.keyword}) marked as reviewed."
    else
      puts "      #{object.class} marked as reviewed."
    end
    action_verb = "reviewed"
  else
    case command
    # keep these in sync with main.rb as best you can
    # last synced: 2020-07-26
    # TODO INSTEAD make this a fuction that's called from here and main.rb
    # something like 'core_editing'
    when '?', 'help', 'wtf', 'fuck'
      puts "Here's what you can do:"
      puts ' Press ENTER to mark the item as reviewed and move onto the next one.'
      puts ' This is the most common thing you will do 90%+ of the time.'
      puts " Marking something as reviewed means you've thought about it, and the current status or state of the task/project is correct."
      puts
      puts 'You can also do one of these against the current item: '
      #        puts " 'co' or 'com' - complete"
      puts " 'c' or 'com' - complete"
      puts " 'd' - delete'"
      puts " 'an' or 'n' - add note'"
      puts " 'r' - rename" 
      puts " 'psm' 'epsm' - edit project support material"
      puts " 'pt action_context <contents of task>' - add a project task to the current project"
      puts
      puts "Additionally, you can use these commands in this context:"
      puts " 't action_context contents of task' - create a adhoc task"
      puts " 'co contents of task' - create an adhoc task in the computer action context"
      puts " 'j contents of task' - create an adhoc task in the job action context"
      puts " 'w contents of task' - create an adhoc task in the waiting action context"
      puts " 's/m contents of task' - create an adhoc task in the waiting action context"
    when 'pt'
      project_task(keyword, content)
    when 'co'
      view_or_add_task('computer', keyword, content)
    when 'j'
      view_or_add_task('job', keyword, content)
    when 'l', 'm', 'msm', 'move', 'later'
      move_someday_maybe(keyword)
    when 'pc' # pc 'whatever you need to do at your computer'
      project_task_maybe(object, 'computer', keyword, content)
    when 'pj' # pj 'whatever you need to do at your job'
      project_task_maybe(object, 'job', keyword, content)
    when 'pw' # pw 'whatever you are waiting on'
      project_task_maybe(object, 'waiting', keyword, content)
    when 's', 'search'
      search(keyword, content)
    when 'sm', 's/m'
      view_or_add_task('someday/maybe', keyword, content)
    when 't'
      task_input(keyword, content)
    when 'p'
      project_input(keyword, content)
    when 'w'
      # Note, 2020-08-23: we are explicitly not making 'w' add a waiting to the current project. This is to ensure consistancy with how 'w' typically works.
      view_or_add_task('waiting', keyword, content)
    when 'e', 'exit','q', 'quit'
      exit # we at least want exit rather than ctrl-c, since that doesn't store history of completed/deleted
    # exit may be enough, sure it'd be nice to get out of the weekly review
    # overall and back to the main prompt, but exiting out of the entire program
    # seems reasonable to me, esp. now that the weekly review subprompt does so much of what the main prompt does
    # also we don't *really* want to encourage people to leave this wr process,
    # esp since they can still create tasks and projects in here
    # TODO MAYBE 
    # next time you look at htis code
    # add this to all of your blocks, expanding them to do/end
    # and reset this variable at end of weekly_review method
    # break if $quit_weekly_review
    #      puts "Leaving weekly review..."
    #     $quit_weekly_review = true
    when 'n', 'an', 'add-note', 'note'
      action_verb = 'add_note'
    when 'c', 'com', 'complete', 'finish', 'done'
      action_verb = 'complete'
    when 'd', 'delete', 'remove'
      action_verb = 'delete'
    when 'psm', 'edit-psm', 'epsm'
      action_verb = 'edit_psm'
    when 'r', 'rename', 'retitle'
      action_verb = 'rename'
    when 'undo'
      if $undo
        $undo[0].send($undo[1])
        puts 'Undo performed. Specifically did this: '
        puts "object: #{$undo[0]}"
        puts "action: #{$undo[1]}"
      else
        puts '$undo variable not set, nothing to undo?'
      end
    else
      puts 'Input unrecognized. Skipping..' # should probably not skip TODO, should loop
    end
    if action_verb
      if action_verb != 'reviewed'
        take_edit_action(action_verb, object)
        puts
        if action_verb == 'rename' # if we're renaming, don't advance to the next
          review_and_maybe_edit(object)        
        end 
      end 
    else
      review_and_maybe_edit(object)        
    end
  end # action.empty?
end # def

# Review all projects and tasks weekly.
# Review all areas of focus/responsibility biweekly.
# Review all goals monthly. # quarterly? per GTD coach
# Review all someday/maybe at least every 10 weeks.
# 2020-08-07: switch from 7 days to 5 to ensure review all work stuff.
# 2021-11-06: now review upto 10% of entire s/m list every week; ensure
#  keep it fresh and we don't have a giant list of doom.
#  see review_need_reviewed
def not_recently_reviewed(object, somedaymaybe = nil)
  one_day_in_seconds = 86400 # 24 * 60 * 60
  five_days_ago = Time.now.to_i - one_day_in_seconds * 5
  two_weeks_ago = Time.now.to_i - one_day_in_seconds * 14 
  a_month_ago = Time.now.to_i - one_day_in_seconds * 30 
  ten_weeks_ago = Time.now.to_i - one_day_in_seconds * 70
  if somedaymaybe
    (object.last_reviewed == nil) or (object.last_reviewed.to_i < ten_weeks_ago)
  elsif object.is_a? Task and object.action_context == 'focus/resp'.to_sym
    (object.last_reviewed == nil) or (object.last_reviewed.to_i < two_weeks_aog)
  elsif object.is_a? Task and object.action_context == 'goals'.to_sym 
    (object.last_reviewed == nil) or (object.last_reviewed.to_i < a_month_ago)
  else
    (object.last_reviewed == nil) or (object.last_reviewed.to_i < five_days_ago)
  end
end 

def review_projects_and_subtasks(projects)
  projects.each do |p|
    puts
    puts "Reviewing project: #{p.keyword}"
    subtasks_to_review = p.tasks.filter { |t| not_recently_reviewed(t) }
    if subtasks_to_review.empty? and p.tasks.empty?
      if $color_only
        print `tput setaf 1` # red
      end 
      puts "    No subtasks! Need to define next action/waiting for this project."
      if $color_only
        print `tput sgr0` # reset colors
      end 
    else
      puts "    #{p}"
      subtasks_to_review.each { |t| review_and_maybe_edit(t, p) }      
    end 
    review_and_maybe_edit(p)
  end
end

def review_need_reviewed
  projects = $data.projects.filter {|p| not_recently_reviewed(p) }
  review_projects_and_subtasks(projects)
  tasks = $data.tasks.filter {|t| not_recently_reviewed(t) }
  tasks.each { |t| review_and_maybe_edit(t) }
  # TODO s/m randomize order of the tasks during weekly review; to prevent
  # habitual memory formation of 'this task is a no review needed, and
  # the next is OK too, and this too'. This should be paired, however,
  # with a new feature to deduplicate/find similar tasks automatically.
  # Often I'll have an idea and put in several ideas about it and if
  # they are no longer close together in the data structure (i.e. so I'll
  # see them together) I might remove all references to them... although
  # that could be a good thing too, cleaning things up... streamlining..

  # TODO s/m it would be nice if S/M (projects and tasks) were in another
  # data structure so I could just do
  #   (need_reviewed($data.s_m)).take(max_sm_for_review)
  # instead of manually interating. That would also handle the 'how do
  # we easily turn projects into someday/maybe objects' problem...

  # Don't review more than 10% of our outstanding someday/maybe tasks
  # even if haven't been reviewed recently. This will also space them out.
  max_sm_for_review = $data.number_of_someday_maybe * 0.1
  somedaymaybe = $data.somedaymaybe.filter { |sm| not_recently_reviewed(sm, true) }
  somedaymaybe = somedaymaybe.take(max_sm_for_review)
  somedaymaybe.each { |sm| review_and_maybe_edit(sm) }
end


# A checklist that requires explict checking to get past each step.
def weekly_review
  def do_until_done(review_step_text)
    print review_step_text
    print ': '
    input = gets.strip
    if input == 'exit'
      exit
    elsif input != 'done'
      do_until_done(review_step_text)
    end
  end
  # todo should probably allow the user to input new tasks here while collecting and stuff.... or release the lock to allow them to use a second instance of extbrain..
  puts "Type 'done' when you've completed each of these fully. Or 'exit' to quit extbrain entirely."
  if $custom_inboxes
    puts "Custom inboxes..."
    $custom_inboxes.each { |inbox| do_until_done(inbox) }
  end
  puts 'Capture'
#  do_until_done('Clarify and organize all of your email')
  do_until_done('Review any meeting notes or scribbled notes')
  do_until_done('Review anything captured on your smartphone/tablet device..pictures, text messages, etc.')

  do_until_done("Review last week's calendar")
  do_until_done("Review next week's calendar")

  

#  do_until_done('Review your waiting folder in your email.')

  review_need_reviewed
  puts "Weekly review done, congrats!"
  $last_weekly_review = Time.now
end

def print_stats
  number_of_projects = $data.number_of_projects
  number_of_tasks = $data.number_of_tasks
  total = number_of_projects + number_of_tasks 
  puts " Total: #{total}. #{number_of_projects} projects and #{number_of_tasks} tasks."
  # TODO stats here regarding average and color coding if in DANGER ZONE? [eg you are having too many tasks/projects/not reviewing enough]
  print "Last weekly review: "

  if $last_weekly_review
    days = Time.now.yday - $last_weekly_review.yday
    if days >= 0
      case 
      when days < 4
        print `tput setaf 2` if $color_only # green
      when days < 7
        print `tput setaf 3` if $color_only # yellow
      when days >= 7 
        print `tput setaf 1` if $color_only # red
      end
      puts "#{days} days ago."
      print `tput sgr0` if $color_only # reset colors
    else
      puts $last_weekly_review.strftime($time_formatting_string)
      puts "Happy New Year(ish)! Start fresh with a weekly review, using the friendly 'wr' command."
      puts "The 'wr' command will only prompt you for things that /need/ review."
      puts
      puts
      puts
      puts "Plus running it will fix this edge case where I can't be arsed/don't know how to fix my algorithm around Time.now.yday."
      puts
      puts "But, in an effort to be useful, the last date of the weekly review was: #{$last_weekly_review.strftime($time_formatting_string)}"
      puts
    end 
  else
    #      puts "NEVER! That's bad. Use the 'wr' command to fix."
    puts "No weekly review yet. Use 'wr' to fix this!"
  end

  # TODO this would be a cool stat to track
  #  puts "Weekly review frequency: #{}"
end

def print_full_stats
# TODO   puts "Reminder to review stats calculation accuracy after you've been using this for two years. 2021-11-01" 
  
  # This all feels slightly hacky, but it should get the job done.
  stats = $data.stats 
  total_projects = stats.sum { |snapshot| snapshot.last } # grab projects for each snapshot
  average_projects = total_projects / stats.count
  current_projects = $data.number_of_projects
  percent_difference_projects = ((average_projects / current_projects.to_f)*100 - 100).abs.to_i
  puts "Average number of projects: #{average_projects}."
  puts "Current number of projects: #{current_projects}."
  if current_projects > average_projects
    puts "Currently we have more projects than average, by #{percent_difference_projects}%."
  else
    puts "Currently we have fewer projects than average, by #{percent_difference_projects}%."
  end
  number_of_tasks = $data.number_of_tasks
  percent_difference_tasks = (($data.number_of_someday_maybe / number_of_tasks.to_f) * 100).to_i
  puts "Someday/maybe is #{percent_difference_tasks}% of our #{number_of_tasks} total tasks."
  # TODO some kind of judgement of percent diff - eg 5% is ok, 10% is warning, 15% is serious, and >20% means immediate weekly review! haha
  
  # average vs current

=begin
  # TODO 
  ## trends
  one_day_in_seconds = 86400 # 24 * 60 * 60
  
  # trend - 2 weeks
  two_weeks_in_seconds = one_day_in_seconds * 14
  two_weeks_ago = Time.now.to_i - two_weeks_in_seconds
  
  two_weeks = @stats.filter(Time.now )

  
  # trend - 2 months
  two_months_in_seconds = two_weeks_in_seconds * 8
  two_months_ago = Time.now.to_i - two_months_in_seconds

  # trend - 6 months
  six_months_in_seconds = two_months_in_seconds * 3
  six_months_ago = Time.now.to_i - six_months_ago_in_seconds
  
  two_months = @stats.filter
  # trend - 2 years
  two_years_in_seconds = two_months_in_seconds * 12
  two_years_ago = Time.now.to_i - two_years_in_seconds
=end  

end
