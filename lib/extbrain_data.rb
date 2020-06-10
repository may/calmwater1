# Created: 2020-05-30
# Revised: 2020-06-10
# Saving and loading of data.

require 'yaml'
require_relative 'project.rb'
require_relative 'task.rb'
require_relative 'habit.rb'
require_relative '../config.rb'


class ExtbrainData
  # todo accessors?
  def initialize()
    # this should probably be @habits but trying global during dev..
    # todo
    load_data
    $habits = Array.new unless $habits
    @projects = Array.new unless @projects
    @tasks = Array.new unless @tasks
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
      $habits = YAML.load(File.read($savefile_habits))
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
      File.open($savefile_habits, 'w') { |f| f.write(YAML.dump($habits)) }
      puts "saved!"
      puts "todo projects"
      puts "todo tasks"
      File.delete($lockfile) # clear lock
    else
      puts "Can't get lock, unable to save."
    end 
  end 

  def projects_number
  end
  def tasks_number
  end
  def projects_number_average
  end
  def tasks_number_average
  end
end
#TODO come up with a better name extbrain-datasabes..


## TODO put all this in a separate file called ProjectsAndTasks.rb, and rename this file to ProjectTask.rb
## I imagine there might be a lot of common accesor methods for this data structure,
## probably enough to warrent a class: ProjectsAndTasks, and save me writing same codeslightly  wrong each time
## .find_task
## .update_task(replaced task object)
## .delete_task(sets deleted flag on that task object)
## .archive_deleted( saves all with deleted flag set to YYYY-MM-DD-trash.ymal with a timestamp)
##  ^ separate code that checks on exit and handles if month # has changed
## .archive_completed( saves all with completed?=true AND date > 1yr? to YYYY-MM-DD-completed.ymal
##  ^ separate code that checks on exit and handles if month # has changed
## .find_project

## TODO $projects_and_tasks = Array.new






#m = [1, 2, 3, 4, "Ruby"]

#sleep 0.9

