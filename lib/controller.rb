# Created: 2020-05-30
# Revised: 2020-06-14
# Assumes $data exists thanks to main.rb

require_relative '../config.rb'
require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'


def project_input(command, keyword, content)
  # view all projects, unless context specified
  # TODO MAYBE or tag specified
  ## ^^ INSTEAD consider GROUPING by TAGS
  ## ^^^ SORT TBD; probably just order projects created in
  if keyword
    if content
      if $data.new_project(content, keyword, $life_context)
        # TODO list project just the one we created
        print "Project created:"
        puts $data.project_exist?(keyword)
        if $data.projects.count < 10 # todo ideally have proper accessor for # of projects
          puts "Change project context with 'plc keyword context') or see config.rb for automatic settings." 
        end
      end
    else # just a keyword
      if $data.defined_life_contexts.include?(keyword.to_sym)
        $data.list_projects(keyword.to_sym)
      end
    end
  else # no keyword or content
    $data.list_projects
  end 
end     
  # p [optional: life_context] or lp - list projects for the current or given life context
  # p all - list all projects regardless of life context
  # p keyword - view project with keyword
  # p keyword title - create project with keyword and title 
#  if not keyword
#    puts "Need to specify a keyword" #TODO
#  end 

  # if p or lp or projects -> list projects
  # if p or project keyword -> list specific project, keyword
  # if pe edit project
 #  todo how to add task?
  # if p keyword content -> create new project with keyword

  
#  case command
#  when 'p', 'proj', 'project' 
    # remember $life_context now exists


def writing_habit_input(keyword, content)
  # h wc 5000
  if $data.habit_exist?(keyword)
    if content
      $data.complete_habit(keyword, content) 
      puts 'Writing habit completed for today! Go you!'
      puts "You wrote #{$data.writing_habit_word_count(keyword)} words today! Average: #{$data.writing_habit_average_word_count(keyword)} words."
      puts
      puts "Tomorrow write: #{$data.writing_habit_average_word_count(keyword)+1} words"
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
    puts "Habit created: #{keyword}." if $data.new_habit(content, keyword)
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
