# Created: 2020-05-30
# Revised: 2020-06-10
# Saving and loading of data.

require 'yaml'
require_relative 'project.rb'
require_relative 'task.rb'
require_relative 'habit.rb'
require_relative '../config.rb'


  
  def projects_number
  end
  def tasks_number
  end
  def projects_number_average
  end
  def tasks_number_average
  end

## .find_task
## .update_task(replaced task object)
## .delete_task(sets deleted flag on that task object)
## .archive_deleted( saves all with deleted flag set to YYYY-MM-DD-trash.ymal with a timestamp)
##  ^ separate code that checks on exit and handles if month # has changed
## .archive_completed( saves all with completed?=true AND date > 1yr? to YYYY-MM-DD-completed.ymal
##  ^ separate code that checks on exit and handles if month # has changed
## .find_project




class ExtbrainData
  # todo accessors? NO, try to encapsulate.
  def initialize()
    # this should probably be @habits but trying global during dev..
    # todo
    load_data
    @habits = Array.new unless @habits
    @projects = Array.new unless @projects
    @tasks = Array.new unless @tasks
  end
  

  def new_habit(content, keyword)
    # todo some kind of checknig to prevent keyword conflicts
    # eg if it exists do keyword1 then keyword2 etc.
    # or hardstop
    # also, todo, make this a generic method across all things
    h = Habit.new(content, keyword, nil)
    ### TODO CHECK TO SEE IF IT EXISTS BY KEYWORD! 2020-06-07 
    # TODO prompt user for trigger? or ??
    @habits << h

end 



  def load_data
    if File.exist?($lockfile)
      $lockfile_locked = true
      exit
    else
      puts "Locking..."
      File.open($lockfile, 'w') {|f| f.write(Process.pid) }
    end
    print "Loading file..."
    if File.exist?($savefile_habits)
      @habits = YAML.load(File.read($savefile_habits))
    else
      puts 
      puts "File not found: #{$savefile_habits}."
      puts 'If this is your first run, you can ignore this message.'
    end
    puts "loaded. TODO #{$projects_number} #{$tasks_number}"
    # stats is a hell no, but knowing how many loaded just might be fun! helps with my rtm statks spreadsheet too
  end
  
  def save_data
    if Process.pid == File.open($lockfile, &:gets).to_i
      print "Saving file..."
      File.open($savefile_habits, 'w') { |f| f.write(YAML.dump(@habits)) }
      puts "saved!"
      puts "todo projects"
      puts "todo tasks"
      File.delete($lockfile) # clear lock
    else
      puts "Can't get lock, unable to save."
    end 
  end 
end 
