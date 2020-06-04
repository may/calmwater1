# Created: 2020-06-01
# Revised: 2020-06-01

def enable_writing_mode
      puts 'Enabling writing mode..'
      $writing_mode = true
#       open file writing_mode.txt
#       append newline
#       append "-- #{Today.now} --"
end

def writing_mode_input(input_string)
  # save stuff via append
  puts 'writing mode magic here'
  puts 'writing mode input TODO'
  
#       append input string to file writing_mode.txt
end

def disable_writing_mode
        puts 'Disabling writing mode..'
        $writing_mode = false
        puts 'TODO close file and append ending timestamp perhaps, but in any case make sure file is safely on disk'
end
