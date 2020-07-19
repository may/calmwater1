# Created: 2020-05-30
# Revised: 2020-07-19
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

def task_list(keyword = nil)
  if keyword
    # keyword is really action_context
    $data.list_tasks(keyword)
  else
    $data.list_tasks
  end
end
  
def task_input(task_action_context,task_body)
#  puts 'currently a no-op, will be implemented later'
#  puts "would be nice if a t no args called 'task_list'"
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
# TODO refactor repeated code into smaller parts? OTOH if it's working and isn't copied again leave it?
  # and just print existing title first, no messing with readline for now
  # this decision made to help/strongly encourage the user to properly define
  # what the desired outcome is *now*. They can easily re-type it if needed from
  # the 'here's what the title is right now' output.
  # If you want to get fancy, you can use readline (or highline if need cross platform)
  # to output a prompt and then put some text in the read buffer so the user can
  # edit what is already there.

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
#  'edit_psm'
#  'add_note'
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
    elsif project_search_results = $data.find_projects(keyword)
      if project_search_results.count > 1
        puts 'More than one project matched search critera.'
        puts 'Choose a project, by entering a number.'
        project_search_results.each_with_index do
          |project,index|
          print index
          print '. ' 
          puts project
        end
        print '>> '
        number = gets.strip
        unless number.empty?
          object_to_operate_on = project_search_results[number.to_i]
        end
        elsif project_search_results.count == 1
        object_to_operate_on = project_search_results.first
      else
        puts "You shouldn't see this. controller.rb/edit_project_or_task - project"
      end # project_search_results.count > 1
    else # not a project
      if content
        t = $data.find_tasks(keyword + ' ' + content)
      else
        t = $data.find_tasks(keyword)
      end
      if t.count > 1
        puts 'More than one project matched search critera.'
        puts 'Choose a task, by entering a number.'
        t.each_with_index do
          |task,index|
          print index
          print '. ' 
          puts task
        end
        print '>> '
        number = gets.strip
        unless number.empty?
          object_to_operate_on = t[number.to_i]
        end
      elsif t.count == 1
         object_to_operate_on = t.first
       elsif t.count == 0
        puts 'No tasks found.'
       else
         puts "You shouldn't see this. controller.rb/edit_project_or_task - task"
       end # t.count > 1
    end # if a_project
    if object_to_operate_on # check for nil
      case action_verb
      when 'add_note'
        add_note(object_to_operate_on)
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

# TODO I should probably refactor into smaller helper functions?
# looks for project with keyword of string
# if exact match found stop, complete, print & give undo option
## undo option implemented via eval
## eg $last_object + $last_operation_opposite
## should yield project.uncomplete
# else looks for task or project with string in title
# else looks for subtask of project w/ string in title
# if several matches, print list and allow user to choose a task or retry their search
# string until a match is found
# TODO implement undo functionality by setting undo variables on each action
def complete_or_delete_task_or_project(string, delete)
  unless string
    if delete
      puts "Need to specify which task or project to delete. Just type a search term."
    else
      puts "Need to specify which task or project to complete. Just type a search term."
    end
  else
    a_project = $data.project_exist?(string)
    if a_project
      if delete
#        $undo = [a_project,'undelete']
        a_project.delete
        puts "Deleted project: #{a_project}"
      else
        a_project.complete
        puts "Completed project: #{a_project}"
      end
    elsif project_search_results = $data.find_projects(string)
      if project_search_results.count > 1
        puts 'More than one project matched search critera.'
        puts 'Choose a project, by entering a number.'
        project_search_results.each_with_index do
          |project,index|
          print index
          print '. ' 
          puts project
        end
        print '>> '
        number = gets.strip
        unless number.empty?
          p = project_search_results[number.to_i]
          if delete
            p.delete
            puts "Deleted project: #{p}"
          else
            p.complete
            puts "Completed project: #{p}"
          end
        else
          puts 'No action taken.'
        end
      elsif project_search_results.count == 1
        p = project_search_results.first
        if delete
          p.delete
          puts "Deleted project: #{p}"
        else
          p.complete
          puts "Completed project: #{p}"
        end
      else
        puts "You shouldn't see this. controller.rb/complete_or_delete_task_or_project - project"
      end
    else
      tasks_result = $data.find_tasks(string)
       if tasks_result.count > 1
         puts 'More than one project matched search critera.'
         puts 'Choose a task, by entering a number.'
         tasks_result.each_with_index do
           |task,index|
           print index
           print '. ' 
           puts task
         end
         print '>> '
         number = gets.strip
         unless number.empty? 
           t = tasks_result[number.to_i]
           if delete
             t.delete
             puts "Deleted task: #{t}"
           else
             t.complete
             puts "Completed task: #{t}"
           end
         end
       elsif tasks_result.count == 1
         t = tasks_result.first # it's an array of one item, hence the .first
        if delete
          t.delete
          puts "Deleted task: #{t}"
        else
          t.complete
          puts "Completed task: #{t}"
        end
      elsif tasks_result.count == 0
        puts 'No tasks found.'
      else
        puts "You shouldn't see this. controller.rb/complete_or_delete_task_or_project - task"
      #todo complete tasks code and undo vars etc.
        # todo delete tasks code and undo vars etc
      end # t.count > 1
    end # if p
  end
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
