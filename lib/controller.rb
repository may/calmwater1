# Created: 2020-05-30
# Revised: 2020-06-10
# Assumes $data exists thanks to main.rb

require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'

def project_list_input
  
  # p = list projects
  # lp = list projects
  # lpw or wp = work projects
  # lph = home projects
  # lpp = personal projects
  # li / lm = list info (or metadata) with optional keyword for specific project

end 

def habit_input(keyword, content)
  no_habits = 'No habits. Create one by typing \'h keyword title of your habit\'' 
  if content
    $data.new_habit(content, keyword)
    puts "Habit created: #{keyword}."
  elsif keyword
    if $data.no_habits?
      puts no_habits 
    else
      $data.complete_habit(keyword) # complete for *today*
      puts "Logged completion of #{keyword} habit for today."
    end 
  else
    # todo how can I not repeat this? no idea, worry about it later -later nick
    if $data.no_habits?
      puts no_habits
    else 
      #todo list all habits

    end 
  end 

end 
