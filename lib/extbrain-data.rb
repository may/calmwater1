# Created: 2020-05-30
# Revised: 2020-05-30

require 'yaml'

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

#File.open('extbrain.yaml', 'w') { |f| f.write(YAML.dump(test)) }
