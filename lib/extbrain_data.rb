# Created: 2020-05-30
# Revised: 2020-06-15
# Methods to access data. Saving and loading of data.

require 'yaml'
require_relative 'project.rb'
require_relative 'task.rb'
require_relative 'habit.rb'
require_relative 'writing_habit.rb'
require_relative '../config.rb'

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
  attr_reader :projects
  # todo accessors? NO, try to encapsulate.
  def initialize()
    # todo
    load_data
    @habits = Array.new unless @habits
    @projects = Array.new unless @projects
    @tasks = Array.new unless @tasks
    puts "#{number_of_projects} projects, #{number_of_tasks} tasks, and #{number_of_work_projects} work projects."
  end

  def number_of_projects
    @projects.count
  end
  
  def number_of_tasks
    if num_tasks = @projects.map { |p| p.task_count }.reduce(:+)
      @tasks.count + num_tasks
    else
      @tasks.count
    end 
  end
  
  def number_of_work_projects
    @projects.select { |p| p.life_context == 'work'.to_sym }.count
  end 

  
  ## TASKS
  
  def new_task(title, action_context, life_context)
    task = Task.new(title, action_context, life_context)
    @tasks << task
  end 

  ## PROJECTS

  def defined_life_contexts
    p = @projects.uniq { |proj| proj.life_context }    
    life_contexts = p.collect { |proj| proj.life_context }
    life_contexts
  end

  def list_projects(life_context = nil)
    if life_context
      proj = @projects.select { |p| p.life_context == life_context.to_sym }
    else
      proj = @projects
    end 
    # Group by tags.
    proj.sort { |a, b| a.tags <=> b.tags }
    proj.each { |p| puts p }
    puts "No projects, yet. Add one with 'p keyword title of your project'" if proj.empty?
  end 
  
  # # TODO decide if color coding useful.
  # # ideas include:
  # # yellow if review date > 7 days
  # # red if review date > 14 days
  # def list_projects_UNFINISHED_STOLEN_FROM_HABITS
  #       @habits.each do |habit|
  #     if habit.completed_today?
  #       print `tput setaf 2` # instruct linux/unix terminal to go green
  #     elsif habit.completed_yesterday?
  #       print `tput setaf 4` # instruct linux/unix terminal to go blue
  #     elsif habit.completed_two_days_ago?
  #       print `tput setaf 3` # instruct linux/unix terminal to go yellow
  #     else
  #       print `tput setaf 1` # instruct linux/unix terminal to go red
  #     end 
  #     puts habit.to_s
  #     print `tput sgr0` # reset colors
  #   end 
  # end 

  # todo test
  def project_exist?(keyword)
    keyword = keyword.to_sym
    @projects.detect { |project| project.keyword == keyword }
  end

  
  def new_project(title, keyword, life_context)
    if project_exist?(keyword)
      puts "Project exists with that keyword: #{keyword}. Try again."
      success = nil
    else
      project = Project.new(title, keyword, life_context)
      @projects << project
      success = true
    end
    success
  end
  
  def change_context_project(keyword, context)
    puts "TODO"
  end 

  ## WRITING HABITS
  
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

  ## HABITS
  
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

  ## SAVING AND LOADING DATA
  
  def load_data
    if File.exist?($lockfile)
      $lockfile_locked = true
      exit
    else
      puts "Locking..."
      File.open($lockfile, 'w') {|f| f.write(Process.pid) }
    end
    print "Loading files..."
    if File.exist?($savefile_habits)
      @habits = YAML.load(File.read($savefile_habits))
    else
      puts "File not found: #{$savefile_habits}."
      puts ' If this is your first run, or you have no habits yet, you can ignore this message.'
    end
    if File.exist?($savefile_projects)
      @habits = YAML.load(File.read($savefile_projects))
    else
      puts "File not found: #{$savefile_projects}."
      puts ' If this is your first run, or you have no projects yet, you can ignore this message.'
    end
    if File.exist?($savefile_tasks)
      @habits = YAML.load(File.read($savefile_tasks))
    else
      puts "File not found: #{$savefile_tasks}."
      puts ' If this is your first run, or you have no tasks, you can ignore this message.'
    end
    puts "loaded."
  end
  
  def save_data(clear_lock=nil)
    if Process.pid == File.open($lockfile, &:gets).to_i
      print "Saving file..." if clear_lock # only be chatty if closing program, otherwise save silently each time
      print 'habits...' if clear_lock
      File.open($savefile_habits, 'w') { |f| f.write(YAML.dump(@habits)) }
      print 'projects...' if clear_lock
      File.open($savefile_projects, 'w') { |f| f.write(YAML.dump(@projects)) }
      print 'tasks...' if clear_lock
      File.open($savefile_tasks, 'w') { |f| f.write(YAML.dump(@tasks)) }
      puts "saved!" if clear_lock
#      puts "todo projects" if clear_lock  TODO TEST
#      puts "todo tasks" if clear_lock TODO TEST
      if clear_lock
        File.delete($lockfile)
      end 
    else
      puts "Can't get lock, unable to save."
    end 
  end 
end 
