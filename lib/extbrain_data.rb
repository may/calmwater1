# Created: 2020-05-30
# Revised: 2020-06-01

require 'yaml'
require_relative 'project.rb'
require_relative 'task.rb'
require_relative 'habit.rb'

class ExtbrainData
  # todo accessors?
  def initialize()
    # this should probably be @habits but trying global during dev..
    load_data
    $habits = Array.new unless $habits
    @projects = Array.new unless @projects
    @tasks = Array.new unless @tasks
  end
  
  def load_data
    print "Loading file..."
    puts "loaded. TODO #{$projects_number} #{$tasks_number}"
    # stats is a hell no, but knowing how many loaded just might be fun! helps with my rtm statks spreadsheet too
  end
  
  def save_data
    print "Saving file..."
    #File.open('extbrain.yaml', 'w') { |f| f.write(YAML.dump(test)) }
    puts "saved! TODO"
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



#m = YAML.load(File.read('extbrain.yaml'))


#m = [1, 2, 3, 4, "Ruby"]

#sleep 0.9

