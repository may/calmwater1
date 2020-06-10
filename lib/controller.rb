# Created: 2020-05-30
# Revised: 2020-06-09

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
  if content
    # todo some kind of checknig to prevent keyword conflicts
    # eg if it exists do keyword1 then keyword2 etc.
    # or hardstop
    # also, todo, make this a generic method across all things
    h = Habit.new(content, keyword, nil)
    ### TODO CHECK TO SEE IF IT EXISTS BY KEYWORD! 2020-06-07 
    # TODO prompt user for trigger? or ??
    $habits << h
    puts "Habit created: #{keyword}."
  elsif keyword
    if $habits.empty?
      puts 'No habits. Create one by typing \'h keyword title of your habit\'' 
    else
      # complete the habit for today
      h = $habits.find_all { |habit| habit.keyword == keyword }
      h = h.first
      h.completed
      puts "Logged completion of #{keyword} habit for today."
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
