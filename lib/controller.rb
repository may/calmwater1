# Created: 2020-05-30
# Revised: 2020-06-03

require_relative 'extbrain_data.rb'
require_relative 'writing_mode.rb'


def habit_input(keyword, content)
  puts "habit_input"
  if content
    # todo some kind of checknig to prevent keyword conflicts
    # eg if it exists do keyword1 then keyword2 etc.
    # or hardstop
    # also, todo, make this a generic method across all things
    h = Habit.new(content, keyword, nil)
    # TODO prompt user for trigger? or ??
    $habits << h
    puts "yay habit created"
  elsif keyword
    if $habits.empty?
      puts 'No habits. Create one by typing \'h keyword title of your habit\'' 
    else
      # complete the habit for today
      $habits.find_all.first.completed { |habit| habit.keyword == keyword }
    end # habits.empty?
  else
    # todo how can I not repeat this?
    if $habits.empty?
      puts 'No habits. Create one by typing \'h keyword title of your habit\''
    else 
      #todo list all habits
      $habits.each { |habit| puts habit.brief_info }
    end 
  end 

end 
