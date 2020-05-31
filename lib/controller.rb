# Created: 2020-05-30
# Revised: 2020-05-31

require_relative 'extbrain_data.rb'
$writing_mode = false
$exit = false

def hello
# Once development finished, update this to 0.2 "testing", with a fixed date
  puts "Welcome to extbrain, version 0.1 (\"prototype\"), #{Time.now.strftime('%Y-%m-%d')}"
  print "Loading file..."
  puts "loaded. TODO"
end
                                                                       
def goodbye
  print "Saving file..."
  puts "saved! TODO"
  "Thank you for using extbrain. Have a good day!"
  exit
end 

# #psudocode #TODO
def command_loop
  goodbye if $exit
  until $exit
    $writing_mode ? print("wm> ") : print("> ")
    input = gets
    dispatch_user_input(input)
  end
end

# # psudocode TODO
def dispatch_user_input(input_string)
  input_string.rstrip! # remove trailing whitespace, which is at minimum a newline
  #  puts "got some input: #{input_string}"
  print "got some input: "
  p input_string
  puts
  
   if $writing_mode
#     unless input_string.strip == '!!' # (to terminate writing mode)
#       append input string to file writing_mode.txt
#     else
#       writing_mode = false
#     end
   else 
     case input_string # todo .strip? should be safe b/c not strip! (preserves originial) and writing mode already handled
     when '!!'
#       writing_mode = true
#       open file writing_mode.txt
#       append newline
#       append "-- #{Today.now} --"
     when 'exit'
       $exit = true
       # TODO MORE cleaneup here like saving? or already saved we assume?
       exit
     end
   end
end 



