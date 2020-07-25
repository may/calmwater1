# Created: 2020-05-30
# Revised: 2020-07-25
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
## .find_project



# you searched: andrew
# results:
#  1. (phone) call andrew and wish him a happy birthday
#  2. (someday/maybe) visit andrew and natalie and try their pizza
#  3. (computer) update the invite with a google meet instead


class ExtbrainData
#  attr_reader :projects
  # todo accessors? NO, try to encapsulate.
  def initialize()
    # todo
    load_data
    @habits = Array.new unless @habits
    @projects = Array.new unless @projects
    @tasks = Array.new unless @tasks
    puts "#{number_of_projects} projects, #{number_of_tasks} tasks, and #{number_of_job_projects} job projects. Total: #{number_of_projects + number_of_tasks}."
  end

  ## COUNTS
  
  def number_of_projects
    projects.count
  end
  
  def number_of_tasks
    tasks.count
  end
  
  def number_of_job_projects
    projects.filter { |p| p.life_context == 'job'.to_sym }.count
  end 

  ## SEARCHING

def filter_to_life_context

end 
  # TODO should this be bound to life context? yes unless using search all
  # s string
  # .downcase to ensure case-insensitive search
  def search(string)
    p = find_projects(string)
    p = filter_to_life_context(p)
    t = find_tasks(string)
    if p.nil? and t.nil?
      nil
    elsif t.nil?
      p
    elsif p.nil?
      t 
    else
      t + p
    end 
  end

  def search_all # including notes, shortcut should be sa
    puts 'todo search_all'
  end
  
  ## TASKS

  def tasks
    tasks_all = @tasks.filter { |task| not (task.completed? or task.deleted?) }
    tasks_all << projects_with_tasks.collect { |proj| proj.tasks }
    tasks_all.flatten!
  end
  
  def new_task(title, action_context, life_context)
    task = Task.new(title, action_context, life_context)
    @tasks << task
  end 

  def list_tasks(action_context = nil)
    if action_context
      tsk = tasks.filter { |t| t.action_context == action_context.to_sym }
    else
      tsk = tasks
    end
    # sort by oldest on top. no .modified, so use .creation.
    # oldest on top to try to avoid procrastionation.
    # may also TODO try randomize sometimes to avoid me skipping the top 5 tasks everytime I look at the list
    tsk.sort_by! {|t| t.created } 
    tsk.each { |t| puts t }
    puts "No tasks, yet. Add one with 'pt' or 't':" if tsk.empty?
    puts "Usage: 't action_context title of your task'" if tsk.empty?
  end 

  # Returns array of tasks containing search_string
  def find_tasks(search_string)
    tasks.select { |task| task.title.downcase.include?(search_string.downcase) }
  end
  
  ## PROJECTS

  def projects
    p = @projects.filter { |project| not (project.completed? or project.deleted?) }
  end

  # TODO filter for completed/deleted
  def projects_with_tasks
    proj_w_tasks = projects.filter { |project| not project.tasks.empty? }
  end
  
  def project_exist?(keyword)
    keyword = keyword.to_sym
    projects.detect { |project| project.keyword == keyword }
  end

  
  # Returns array of projects containing search_string
  def find_projects(search_string)
    projs = projects.filter { |project| project.title.downcase.include?(search_string.downcase) }
    projs << projects.filter { |project| project.keyword.to_s.downcase.include?(search_string.downcase) }
    projs.flatten!
    if projs.empty?
      nil
    else
      projs
    end
  end
  
  def defined_life_contexts
    p = @projects.uniq { |proj| proj.life_context }    
    life_contexts = p.collect { |proj| proj.life_context }
    life_contexts
  end

  # todo use projects to filter out completed/deleted
  # ^ I think that is done, as of 7/15 but leave this until 8/1 unless you explicityl test
  def list_projects(life_context = nil)
    if life_context
      life_context = life_context.to_sym
      proj = projects.filter { |p| p.life_context == life_context.to_sym }
    else
      proj = projects
    end 
    # Group by tags.
    proj.sort { |a, b| a.tags <=> b.tags }
    proj.each { |p| puts p }
    puts "No projects, yet. Add one with 'p keyword title of your project'" if proj.empty?
  end 
  
  # # TODO decide if color coding useful for projects
  # # if so steal tput from habits list
  # # ideas include:
  # # yellow if review date > 7 days
  # # red if review date > 14 days
  

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
      if $color_only
        if habit.completed_today?
          print `tput setaf 2` # instruct linux/unix terminal to go green
        elsif habit.completed_yesterday?
          print `tput setaf 4` # instruct linux/unix terminal to go blue
        elsif habit.completed_two_days_ago?
          print `tput setaf 3` # instruct linux/unix terminal to go yellow
        else
          print `tput setaf 1` # instruct linux/unix terminal to go red
        end
      end
      puts habit.to_s
      if $color_only
        print `tput sgr0` # reset colors
      end
    end 
  end 

  def habit_exist?(keyword)
    @habits.detect { |habit| habit.keyword == keyword }
  end
  
  def complete_habit(keyword, word_count_or_yesterday_flag = nil)
    h = habit_exist?(keyword)
    if h
      h.completed(word_count_or_yesterday_flag)
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
    if File.exist?($save_file_habits)
      @habits = YAML.load(File.read($save_file_habits))
    else
      puts "File not found: #{$save_file_habits}."
      puts ' If this is your first run, or you have no habits yet, you can ignore this message.'
    end
    if File.exist?($save_file_projects)
      @projects = YAML.load(File.read($save_file_projects))
    else
      puts "File not found: #{$save_file_projects}."
      puts ' If this is your first run, or you have no projects yet, you can ignore this message.'
    end
    if File.exist?($save_file_tasks)
      @tasks = YAML.load(File.read($save_file_tasks))
    else
      puts "File not found: #{$save_file_tasks}."
      puts ' If this is your first run, or you have no tasks, you can ignore this message.'
    end
    puts "loaded."
  end

  # We save freqeuntly, and clear_lock being true means it's the final save of the session.
  def save_data(clear_lock=nil)
    if Process.pid == File.open($lockfile, &:gets).to_i
      if clear_lock
        print "Archiving completed and deleted tasks & projects..."
        # If you ever edit this code, be sure to use @projects & @tasks; projects/tasks already exclude completed/deleted.
        p = @projects.filter { |project| (project.completed? or project.deleted?) }
        unless p.empty?
          File.open($archive_file_projects, 'a') { |f| f.write(YAML.dump(p)) }
          @projects = @projects - p # remove completed/deleted
        end
        
        t = @tasks.filter { |task| (task.completed? or task.deleted?) }
        unless t.empty?
          File.open($archive_file_tasks, 'a') { |f| f.write(YAML.dump(t)) }
          @tasks = @tasks - t # remove completed/deleted
        end
        puts "archival complete."
      end
      print "Saving file..." if clear_lock # only be chatty if closing program, otherwise save silently each time
      print 'habits...' if clear_lock
      File.open($save_file_habits, 'w') { |f| f.write(YAML.dump(@habits)) }
      print 'projects...' if clear_lock
      File.open($save_file_projects, 'w') { |f| f.write(YAML.dump(@projects)) }
      print 'tasks...' if clear_lock
      File.open($save_file_tasks, 'w') { |f| f.write(YAML.dump(@tasks)) }
      puts "saved!" if clear_lock
      if clear_lock
        File.delete($lockfile)
      end 
    else
      puts "Can't get lock, unable to save."
    end 
  end 
end 
