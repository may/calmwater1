# Created: 2020-05-30
# Revised: 2020-05-30

require_relative 'extbrain_data.rb'
require 'tty-reader'

# TODO - escape to cancel or exit?
# trying exit for now, with ctl-c 2020-05-30 
def command_loop
  reader = TTY::Reader.new
  reader.on(:keyctrl_c, :keyescape) do
    puts "Exiting..."
    exit
  end
  loop do
    puts reader.read_line('=> ')
  end
end 





def hello
  puts "Welcome to extbrain, version 0.1 (\"prototype\"), 2020-05-30"
end
                                                                       
def goodbye
  "Thank you for using extbrain. Have a good day!"
end 


