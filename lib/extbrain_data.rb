# Created: 2020-05-30
# Revised: 2020-06-12
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

  def change_context_task # ??? unsure if needed, prolly
  end

  # TODO decide if color coding useful.
  # ideas include:
  # yellow if review date > 7 days
  # red if review date > 14 days
  def list_projects
        @habits.each do |habit|
      if habit.completed_today?
        print `tput setaf 2` # instruct linux/unix terminal to go green
      elsif habit.completed_yesterday?
        print `tput setaf 4` # instruct linux/unix terminal to go blue
      elsif habit.completed_two_days_ago?
        print `tput setaf 3` # instruct linux/unix terminal to go yellow
      else
        print `tput setaf 1` # instruct linux/unix terminal to go red
      end 
      puts habit.to_s
      print `tput sgr0` # reset colors
    end 

  end 
  
  def new_project(title, keyword, life_context)
    project = Project.new(title, keyword, life_context)
    @projects << project
  end
  
  def change_context_project(keyword, context)
  end 
  
  def writing_habit_word_count(keyword)
    h = habit_exist?(keyword)
    if h
      h.latest_word_count
    else
      puts "No habit found for keyword: #{keyword}. No word count available." #hopefully never hit this..
    end 
  end 

  def writing_habit_average_word_count(keyword)
    h = habit_exist?(keyword)
    if h
      h.average_word_count
    else
      puts "No habit found for keyword: #{keyword}. No average word count available." #hopefully not hit this either
    end 
  end 
  
  def list_habits()
    @habits.each do |habit|
      if habit.completed_today?
        print `tput setaf 2` # instruct linux/unix terminal to go green
      elsif habit.completed_yesterday?
        print `tput setaf 4` # instruct linux/unix terminal to go blue
      elsif habit.completed_two_days_ago?
        print `tput setaf 3` # instruct linux/unix terminal to go yellow
      else
        print `tput setaf 1` # instruct linux/unix terminal to go red
      end 
      puts habit.to_s
      print `tput sgr0` # reset colors
    end 
  end 

  def habit_exist?(keyword)
    @habits.detect { |habit| habit.keyword == keyword }
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
  
  def save_data(clear_lock=nil)
    if Process.pid == File.open($lockfile, &:gets).to_i
      print "Saving file..." if clear_lock # only be chatty if closing program, otherwise save silently each time
      File.open($savefile_habits, 'w') { |f| f.write(YAML.dump(@habits)) }
      puts "saved!" if clear_lock
      puts "todo projects" if clear_lock
      puts "todo tasks" if clear_lock
      if clear_lock
        File.delete($lockfile)
      end 
    else
      puts "Can't get lock, unable to save."
    end 
  end 
end 
