# Created: 2020-05-28
# Revised: 2020-08-09

require_relative 'common_project_task'

# TODO test tasks/do implementaiton @tasks

class Project < CommonProjectTask
  attr_accessor_with_logging :keyword, :psm
  attr_reader :tags, :life_context

  def initialize(title, keyword, life_context = :personal)  # Project
    super(title, life_context)
    @keyword = keyword.to_sym
    @tags = Array.new
    @psm = ""
    @tasks = Array.new
  end

  # sure this would be nice, but they should be filtered out b/c parent project is completed.
  #plus as soon as user exists extbrain the whole project (AND subtasks) will be archived.
#  def complete
#    super
#    plus complete all @tasks
#  end
  
  # Expects tags to be an array of symbols, but a single symbol is ok too.
  # You can also just do p1.tags << 'tagname'
  def tags=(tags)
    if tags.is_a? Symbol
      tags = [tags]
    elsif tags.is_a? Array
      tags = tags.map { |tag| tag.to_sym }
    elsif tags.is_a? String
      tags = [tags.to_sym]
    else
      puts "Hey! Your tags weren't a symbol, array or string, so no promises things will work. Data saved though.."
    end
    add_note("Updated tags:\n old: #{@tags}\n new: #{tags}")
    @tags = tags
  end

  def tasks
    tasks_all = @tasks.filter { |task| not (task.completed? or task.deleted?) }
  end

  # Includes deleted/completed tasks.
  def tasks_all
    @tasks
  end

  def add_task(title, action_context)
    # I hate to say this, but hardcode the keyword of the project into the title
    # that a task lives inside so that when you are looking at tasks
    # outside of the context of a project you'll know what project they're tied to.
    # This will look bad/confuse the user if you ever change the project keyword.
    # But the data structures will still be there, so it's not totally terrible.
    # And as those tasks get completed and new ones added it will mitigate itself.
    # It's still a hack, but it's better than nothing right now.
    # see: controller.rb/project_keyword
    #    title = "(pt: #{keyword}) #{title}" # Hard code, v1
    title = "(proj: #{keyword}) #{title}" # Hard code, v2
    task = Task.new(title, action_context, @life_context)
    @tasks << task
    task
  end


  def task_count
    @tasks.count
  end 

#  def delete_task(task)
#  end

  # def remove_task(task) ? If you need to move a task from project A to project B..
  # what about an explicit move command instead? Let the data layer handle the mucking about.

  def life_context=(new_life_context)
    add_note("Updated life_context:\n old: #{@life_context}\n new: #{new_life_context.to_sym}")
    @life_context = new_life_context.to_sym
    @tasks.each { |t| t.life_context = new_life_context.to_sym }
  end 
  
  def complete_task(task)
  
  end

  def view_project
    puts self # use to_s
    tasks.each { |t| puts " #{t.to_s(true)}" }
  end 

  def view_project_and_notes
    view_project
    self.view_notes
  end

  # try the elegent red only option, else redline the whole thing=>less crusty code
  def puts_project
    if @tasks.count == 0
      if $color_only
        print `tput setaf 1` # red
      end 
      print "[#{@tasks.count}!]"
    else
      print "[#{@tasks.count}]"
    end # tasks == 0
    puts " (#{@keyword}) #{@title}"
    if $color_only
      print `tput sgr0` # reset colors
    end
  end 
  
  def to_s
    if @tags.empty?
    #      "{#{@tasks.count}} (#{@keyword}) [#{@life_context}] #{@title}"
          "[#{@tasks.count}] (#{@keyword}) #{@title}"
    else
      #      "{#{@tasks.count}} (#{@keyword}) [#{@life_context}] {#{@tags}} #{@title}"
      "[#{@tasks.count}] (#{@keyword}) {#{@tags}} #{@title}"
    end 
  end 
end

