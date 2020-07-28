# Created: 2020-05-30
# Revised: 2020-07-28
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

def change_life_context(new_life_context)
  if new_life_context.nil?
    puts "Current context is: #{$life_context}"
    puts "Proper usage: context new_context"
  else
    $life_context = new_life_context.to_sym
    unless $data.defined_life_contexts.include?($life_context)
      puts "WARNING: the context '#{$life_context}' not used anywhere in your data."
      puts "This is OK if you're starting a new life context or know what you're doing."
      puts 
      puts "Otherwise, please call 'context' again and use one of thes contexts: "
      $data.defined_life_contexts.each {|lc| puts "  #{lc}" }
    end
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
def edit_project_or_task(action_verb, keyword, content)
  unless keyword
    puts "Need to specify which task or project in order to #{action_verb}."
    puts "For a project, specify a keyword or type a seach term. "
    puts "For tasks, just type a search term."
    puts "Multi-word searching is supported. TODO."
  else
    object_to_operate_on = nil
    results = $data.search(keyword, content, $life_context)
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

def task_list(keyword = nil)
  if keyword
    # keyword is really action_context
    $data.list_tasks(keyword)
  else
    $data.list_tasks
  end
end
  
def task_input(task_action_context,task_body)
  if task_action_context
    if task_body
      puts $data.new_task(task_body,task_action_context,$life_context)
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
#  new_task(title, action_context, life_context)
#        if $data.new_project(content, keyword, $life_context)
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
#
# If you need to edit what's there, see readline or highline (if cross-platfrom needed).

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
  puts "Deleted #{object.class}: #{object}. Undo available if needed."
end

def complete_task_or_project(object)
  $undo = [object,'uncomplete']
  object.complete
  puts "Completed #{object.class}: #{object}. Undo available if needed."
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

# plc
def project_life_context(keyword, new_life_context)
  if keyword.nil? or new_life_context.nil?
    puts "Proper usage: plc keyword new_life_context"
  else
    if p = $data.project_exist?(keyword)
      p.life_context = new_life_context.to_sym
    else
      puts "No project found with keyword: #{keyword}. Unable to update life context."
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
  # p [optional: life_context] or lp - list projects for the current or given life context
  # p keyword - view project with keyword
  # p keyword title - create project with keyword and title 

  # 'p' or 'lp' etc : view all projects, unless context specified
  # TODO MAYBE or tag specified
  ## ^^ INSTEAD consider GROUPING by TAGS
  ## ^^^ SORT TBD; probably just order projects created in
  # 'p keyword some project' # creates some project w/ keyword of keyword
  if keyword
    if content
      if $data.new_project(content, keyword, $life_context)
        print "Project created: "
        puts $data.project_exist?(keyword)
        if $data.projects.count < 10 # todo ideally have proper accessor for # of projects
          puts "Change project context with 'plc keyword context') or see config.rb for automatic settings." 
        end
      end
    else # just a keyword
      if $data.defined_life_contexts.include?(keyword.to_sym)
        $data.list_projects(keyword) # life context
      else # just a project keyword, not a life context
        find_and_show_project(keyword)
      end
    end # content
  else # no keyword or content
    if $time_sensitive_life_context
      $data.list_projects($life_context)
    else
      $data.list_projects
    end #time_sensitive
  end #keyword
end # def

def search(keyword, content)
  if keyword
    results = $data.search(keyword, content, $life_context)
    if results 
      results.each { |p_or_t| puts p_or_t }
    else
      puts "No results found for query: #{string}."
    end 
  else
    puts 'Empty query. Try again.'
  end
end


def writing_habit_input(keyword, content)
  # h wc 5000
  if $data.habit_exist?(keyword)
    if content
      $data.complete_habit(keyword, content) 
      puts 'Writing habit completed for today! Go you!'
      puts "You wrote #{$data.writing_habit_word_count(keyword)} words today! Average: #{$data.writing_habit_average_word_count(keyword)} words."
      puts
      tomorrow_goal = $data.writing_habit_average_word_count(keyword) + 1
      tomorrow_total_goal = content.to_i + tomorrow_goal
      puts "Tomorrow write: #{tomorrow_goal} words, for a total of #{tomorrow_total_goal}."
    else
      puts "Please try again with the current TOTAL word count, eg 'h wc 5000', please"
    end 
  else
    puts "Habit created: #{keyword}." if $data.new_habit(content, keyword, true)
  end         
end 

def habit_input(keyword, content)
  no_habits = 'No habits. Create one by typing \'h keyword title of your habit\'' 
  if 'wc' == keyword
    writing_habit_input(keyword, content)
  elsif content
    if content == 'yesterday'
      puts "Logged completion of #{keyword} habit for yesterday." if $data.complete_habit(keyword, true)
    else
      puts "Habit created: #{keyword}." if $data.new_habit(content, keyword)
    end 
  elsif keyword
    if $data.no_habits?
      puts no_habits 
    else
      puts "Logged completion of #{keyword} habit for today." if $data.complete_habit(keyword)
    end 
  else
    if $data.no_habits?
      puts no_habits
    else
      #todo list all habits
      $data.list_habits
    end 
  end 
end 

# todo if project, allow adding pt
# else allow t at any time
def review_and_maybe_edit(object)
  action_verb = nil
  unless object.is_a? Task and object.action_context == 'someday/maybe'.to_sym
    puts object
    print '>> '
    action = gets.strip
    #  puts action
    #  p action
    #  puts "action.empty? #{action.empty?}"
    #  puts "action_verb.nil? #{action_verb.nil?}"
    
    # ENTER or space to go to next item, eg return from this function, after setting reviewed date
    if action.empty?
      object.reviewed
      puts "#{object.class} marked as reviewed."
    else
      case action
      # keep these in sync with main.rb as best you can
      # last synced: 2020-07-26
      # TODO INSTEAD make this a fuction that's called from here and main.rb
      # something like 'core_editing'
      when 'e', 'exit','q', 'quit'
        puts 'not implemented yet. try ctrl-c'
      # next time you look at htis code
      # add this to all of your blocks, expanding them to do/end
      # and reset this variable at end of weekly_review method
      # break if $quit_weekly_review
      #      puts "Leaving weekly review..."
      #     $quit_weekly_review = true
      when 'n', 'an', 'add-note', 'note'
        action_verb = 'add_note'
      when 'co', 'com', 'complete', 'finish', 'done'
        action_verb = 'complete'
      when 'd', 'delete', 'remove'
        action_verb = 'delete'
      when 'psm', 'edit-psm', 'epsm'
        action_verb = 'edit_psm'
      when 'r', 'rename', 'retitle'
        action_verb = 'rename'
      else
        puts 'Input unrecognized. Skipping..' # should probably not skip TODO, should loop
      end
      if action_verb
        take_edit_action(action_verb, object)
      end
    end # action.empty?
  end # task & action == s/m
end # def

def not_recently_reviewed(object)
  the_7_days_ago_timestamp = Time.now.to_i - 7*24*60*60
  (object.last_reviewed == nil) or (object.last_reviewed.to_i < the_7_days_ago_timestamp)
end 

def review_projects_and_subtasks(projects)
  projects.each do |p|
    puts "Project, so reviewing tasks first."
    puts "Here is the project: #{p}"
    subtasks_to_review = p.tasks.filter { |t| not_recently_reviewed(t) }
    subtasks_to_review.each { |t| review_and_maybe_edit(t) }
    review_and_maybe_edit(p)
  end
end

def review_need_reviewed
  projects = $data.projects.filter {|p| not_recently_reviewed(p) }
  review_projects_and_subtasks(projects)
  tasks = $tasks.filter {|t| not_recently_reviewed(t) }
  review_and_maybe_edit(tasks)
end 


# A checklist that requires explict checking to get past each step.
def weekly_review
  def do_until_done(review_step_text)
    print review_step_text
    until (gets.strip == 'done')
      print review_step_text
    end
  end
#  do_until_done('Clarify and organize all of your email.')
#  do_until_done('Review your waiting folder in your email.')

  review_need_reviewed
end
