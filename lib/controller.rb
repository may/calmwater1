# Created: 2020-05-30
# Revised: 2020-07-19
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

# SELECTION FUNCITONS

def narrow_project_results_to_one(search_string)
  projects_result = $data.find_projects(search_string)
  if projects_result == nil
    puts 'No projects found.'
    nil
  elsif projects_result.count > 1
    puts 'More than one project matched search critera.'
    puts 'Choose a project, by entering a number.'
    puts 'Press ENTER to search for tasks.'
    projects_result.each_with_index do
      |project,index|
      print index+1 # make the list start at 1 for the user
      print '. ' 
      puts project
    end
    print '>> '
    number = gets.strip
    unless number.empty?
      index_to_use = number.to_i-1 # convert from what we showed user to what we have internally
      projects_result[index_to_use]
    end
  elsif projects_result.count == 1
    projects_result.first # it's an array of one item, hence the .first
  elsif projects_result.count == 0
    puts 'No projects found.'
    nil
  end
end

def narrow_task_results_to_one(search_string)
  tasks_result = $data.find_tasks(search_string)
  if tasks_result.count > 1
    puts 'More than one task matched search critera.'
    puts 'Choose a task, by entering a number.'
    tasks_result.each_with_index do
      |task,index|
      print index+1 # make the list start at 1 for the user
      print '. ' 
      puts task
    end
    print '>> '
    number = gets.strip
    unless number.empty?
      index_to_use = number.to_i-1 # convert from what we showed user to what we have internally
      tasks_result[index_to_use]
    end
  elsif tasks_result.count == 1
    tasks_result.first # it's an array of one item, hence the .first
  elsif tasks_result.count == 0
    puts 'No tasks found.'
    nil
  end
end

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
      $data.new_task(task_body,task_action_context,"unused")
      # Not sure I'll actually use life_context with tasks, although I could see the benefit of a single 'computer' list across work and personal and freelance and home, seprated by life context, but for now we'll just default to 'unused' and if this is a problem we have the structures in place to revisit. 2020-07-15.
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
  note = gets.strip
  if note.empty?
    puts 'No note added.'
  else
    project_or_task.add_note(note)
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
  else
    a_project = $data.project_exist?(keyword)
    if a_project
      object_to_operate_on = a_project
    elsif object_to_operate_on = narrow_project_results_to_one(keyword)
    else # not a project or user wants tasks
      if action_verb == 'edit_psm'
        puts "Can't edit project support material on a *task*. Exiting. Try 'n' for add note, instead."
      else
        if content
          object_to_operate_on = narrow_task_results_to_one(keyword + ' ' + content)
        else
          object_to_operate_on = narrow_task_results_to_one(keyword)
        end
      end
    end # if a_project
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
      "No action taken."
    end
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


# plc
def project_life_context(keyword,new_life_context)
  if keyword.nil? or new_life_context.nil?
    puts "Proper usage: plc keyword new_life_context"
  else
    if p = $data.project_exist?(keyword)
      p.life_context=new_life_context
    else
      puts "No project found with keyword: #{keyword}. Unable to update life context."
    end
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
      print p.keyword 
      print ' ' 
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
        if project = $data.project_exist?(keyword)
          project.view_project
        else
          puts "No project found with keyword: #{keyword}."
        end 
      end
    end
  else # no keyword or content
    $data.list_projects
  end 
end     

def search(string)
  if string
    $data.search(string)
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
