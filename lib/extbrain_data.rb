# Created: 2020-05-30
# Revised: 2020-06-11
# Methods to access data. Saving and loading of data.

require 'yaml'
require_relative 'project.rb'
require_relative 'task.rb'
require_relative 'habit.rb'
require_relative 'writing_habit.rb'
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



# you searched: andrew
# results:
#  1. (phone) call andrew and wish him a happy birthday
#  2. (someday/maybe) visit andrew and natalie and try their pizza
#  3. (computer) update the invite with a google meet instead


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

  def new_task(title, action_context, life_context)
    task = Task.new(title, action_context, life_context)
    @tasks << task
  end 
  
  def list_habits
    @habits.each { |habit| puts habit.brief_info }
  end
  
  def complete_habit(keyword, word_count = nil)
    h = habit_exist?(keyword)
    if h
      h.completed(word_count)
      success = true
    else
      puts "No habit found for keyword: #{keyword}. Can't complete non-existant habit."
      success = false
    end
    success
  end 
  
  def no_habits?
    @habits.empty?
  end 
  
  def new_habit(content, keyword, writing_habit = nil)
    # todo some kind of checknig to prevent keyword conflicts
    # eg if it exists do keyword1 then keyword2 etc.
    # or hardstop
    # also, todo, make this a generic method across all things
    if habit_exist?(keyword)
      puts "Habit exists with that keyword: #{keyword}. Try again."
      success = nil
    else 
      if writing_habit
        h = WritingHabit.new(content, keyword, nil)
      else
        h = Habit.new(content, keyword, nil)
      end
      @habits << h
      success = true
    end 
    success
  end

  def list_habits()
    @habits.each { |habit| puts habit }
  end 

  def habit_exist?(keyword)
    @habits.detect { |habit| habit.keyword == keyword }
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
