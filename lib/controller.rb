# Created: 2020-05-30
# Revised: 2020-06-11
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


def writing_habit_input(keyword, content)
  # h wc 5
  if $data.habit_exist?(keyword)
    if content
      $data.complete_habit(keyword, content) # complete for today habit, with word count of 5 (in example above)
      puts 'Writing habit completed for today! Go you!'
    else
      puts "Please try again with the word count, eg 'h wc 5', please"
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
