# Created: 2020-05-30
# Revised: 2020-06-07

require_relative 'lib/controller'
require_relative 'config.rb'

$writing_mode = false

def startup
  $data = ExtbrainData.new
end

at_exit do
  if $lockfile_locked
    puts "Can't get lock... exiting.."
  else
    $projects_and_tasks.save_data
    puts "Thank you for using extbrain. Have a good day!"
  end 
end



def command_loop
  while true 
    $writing_mode ? print("wm> ") : print("> ")
    input = gets
    dispatch_user_input(input)
  end
end



def dispatch_user_input(input_string)
  input_string.rstrip! # remove trailing whitespace, which is at minimum a newline
  if $writing_mode
    unless 'exit' == input_string or '!!' == input_string
      writing_mode_input(input_string)
    else
      disable_writing_mode
    end
  else
    three_pieces = input_string.split(' ',3)
    command = three_pieces.first
    keyword = three_pieces[1]
    content = three_pieces[2]
    case command
    when '!!', 'wm'
      enable_writing_mode
    when 'exit'
      exit
    when 'h', 'habit'
      habit_input(keyword, content)
    when 'p', 'proj', 'project', 'projects', 'lp'
      project_input(keyword, content)
    end
   end
end 





# Once development finished, update this to 0.2 "testing", with a fixed date
puts "Welcome to extbrain, version 0.1 (\"prototype\"), #{Time.now.strftime('%Y-%m-%d')}"
startup
command_loop

