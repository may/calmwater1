# Created: 2020-05-30
# Revised: 2020-06-25
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

def task_input(task_action_context,task_body)
  # t action_context description_of_action_that_needs_to_be_taken
  # t computer email bob re: request for widgets
  # t house get the ladder from the garage, grab the hose and clean the gutters
  # t foo = create task w/ content foo
  # pt is how you create a project task
  # ^todo make this print whenever you have less than 10 tasks
#  new_task(title, action_context, life_context)
#        if $data.new_project(content, keyword, $life_context)
end

def project_edit(keyword, content)
  puts 'todo'
end 

def project_task(keyword, content)
  # pt keyword some text about my task - adds a new task 'some text about my task' to the project specified by keyword, or errors of no keyword found
  if $data.project_exist?(keyword)
  # todo figure out how to add a task to project
  # check datarb
    #then check project  
  else
    puts "No project found with keyword: #{keyword}."
  end 
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
