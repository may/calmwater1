# Created: 2020-05-30
# Revised: 2020-06-12
# Assumes $data exists thanks to main.rb

require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

def project_input(commond, keyword, content)
  # p [optional: life_context] or lp - list projects for the current or given life context
  # p all - list all projects regardless of life context
  # p keyword - view project with keyword
  # p keyword title - create project with keyword and title 

  # p <keyword> <content>
  # ^ assumes context due to time of day
  # should also print what was created and the context

  # if p or lp or projects -> list projects
  # if p or project keyword -> list specific project, keyword
  # if pe edit project
 #  todo how to add task?
  # if p keyword content -> create new project with keyword

  
#  case command
#  when 'p', 'proj', 'project' 
  if not keyword
    puts "Need to specify a keyword" #TODO

  if true #8-5 M-F assume work todo
    life_context = :work
  else
    life_context = :personal
  end 
  if p = $data.new_project(content, keyword, life_context) #todo 
      puts "Project created with: #{keyword} in life context: #{life_context}. (Change context with 'plc keyword context')"
      puts content
      p.tags = 'test tag' # todo figure out why this isn't working when tests pass just fine
      puts p
      # todo add ???
  end 
  
  # plc keyword context edit context
  
  # p = list projects
  # lp = list projects
  # lpw or wp = work projects
  # lph = home projects
  # lpp = personal projects
  # li / lm = list info (or metadata) with optional keyword for specific project

end 


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
