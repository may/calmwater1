# Created: 2020-05-30
# Revised: 2020-08-02
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
    print "Last weekly review: "
    if $last_weekly_review_done
      days = Time.now.yday - $last_weekly_review_done.yday
      if days >= 0
        case 
        when days < 4
          print `tput setaf 2` if $color_only # green
        when days < 7
          print `tput setaf 3` if $color_only # yellow
        when days > 8 
          print `tput setaf 1` if $color_only # red
        end
        puts "#{days} days ago."
        print `tput sgr0` if $color_only # reset colors
      else
        puts $last_weekly_review_done.strftime($time_formatting_string)
        puts "Happy New Year(ish)! Start fresh with a weekly review, using the friendly 'wr' command."
        puts "The 'wr' command will only prompt you for things that /need/ review."
        puts
        puts
        puts
        puts "Plus running it will fix this edge case where I can't be arsed/don't know how to fix my algorithm around Time.now.yday."
        puts
        puts "But, in an effort to be useful, the last date of the weekly review was: #{$last_weekly_review_done.strftime($time_formatting_string)}"
      end 
    else
      puts "NEVER! That's bad. Use the 'wr' command to fix."
    end
  end

  ## COUNTS
  
  def number_of_projects
    # Points to @projects to get the full count, regardless of life context.
    # Assumes the code that removes/archives the completed or deleted projects
    # continues to operate sucessfully on each save.
    @projects.count
  end
  
  def number_of_tasks
    # Points to @tasks to get the full count, regardless of life context.
    # Assumes the code that removes/archives the completed or deleted tasks
    # continues to operate sucessfully on each save.
    tasks_all = @tasks.dup
    tasks_all << projects_with_tasks.collect { |proj| proj.tasks }
    tasks_all.flatten!
    tasks_all.count
  end
  
  def number_of_job_projects
    # Needs to be @projects, and the newer remove-completed/deleted-on-save code should
    # ensure the number is correct without filtering for completed/deleted.
    @projects.filter { |p| p.life_context == 'job'.to_sym }.count
  end 

  ## SEARCHING

  def filter_to_life_context(array, life_context_desired)
    unless array.nil?
      array = array.filter { |t_or_p| t_or_p.life_context == life_context_desired }
    end 
  end 

  # s string
  # .downcase to ensure case-insensitive search
  def search(keyword, content, life_context)
    if keyword and content
      string = keyword + ' ' + content
    elsif keyword
      string = keyword
    end
    p = find_projects(string)
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
    # should also not filter to life context.. hence 'all'
    # TODO if you implement this, need to account for completed and deleted at least as an option. grabbing those files and reading from disk.
    puts 'todo search_all'
  end
  
  ## TASKS

  def tasks
    tasks_all = @tasks.filter { |task| not (task.completed? or task.deleted?) }
    tasks_all << projects_with_tasks.collect { |proj| proj.tasks }
    tasks_all.flatten!
    tasks_all = filter_to_life_context(tasks_all, $life_context)
  end
  
  def new_task(title, action_context, life_context)
    task = Task.new(title, action_context, life_context)
    @tasks << task
    task
  end 

  # Returns array of tasks containing search_string
  def find_tasks(search_string)
    tasks.filter { |task| task.title.downcase.include?(search_string.downcase) }
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

  
  ## PROJECTS

  def projects
    p = @projects.filter { |project| not (project.completed? or project.deleted?) }
    p = filter_to_life_context(p, $life_context)
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
    projs.uniq! # since we search both title and keyword, ensure we only list each project once
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
      proj = projects # consider projects.dup if you use sort!
    end 
    ## Group by tags.
    ## TODO as of 2020-08-09, not using tags, so skip this
    ##    proj.sort { |a, b| a.tags <=> b.tags }
    proj = proj.sort { |a, b| a.keyword <=> b.keyword }
    proj.each { |p| p.puts_project }
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
    if File.exist?($save_file_last_weekly_review_done)
      $last_weekly_review_done = YAML.load(File.read($save_file_last_weekly_review_done))
    end
    puts "loaded."
  end

  # We save freqeuntly, and clear_lock being true means it's the final save of the session.
  def save_data(clear_lock=nil)
    if Process.pid == File.open($lockfile, &:gets).to_i
      if clear_lock # only be chatty if closing program, otherwise save silently each time
        print "Archiving completed and deleted tasks & projects..."
        # If you ever edit this code, be sure to keep using @projects & @tasks; projects/tasks already exclude completed/deleted.
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
      print "Saving file..." if clear_lock 
      print 'habits...' if clear_lock
      File.open($save_file_habits, 'w') { |f| f.write(YAML.dump(@habits)) }
      print 'projects...' if clear_lock
      File.open($save_file_projects, 'w') { |f| f.write(YAML.dump(@projects)) }
      print 'tasks...' if clear_lock
      File.open($save_file_tasks, 'w') { |f| f.write(YAML.dump(@tasks)) }

      # if saving on exit
      if clear_lock
        if $last_weekly_review_done
          File.open($save_file_last_weekly_review_done, 'w') { |f| f.write(YAML.dump($last_weekly_review_done)) }
          puts 'weekly review status...'
        end
        File.delete($lockfile)
        puts "saved!" if clear_lock

      end 
    else
      puts "Can't get lock, unable to save."
    end 
  end 
end 
