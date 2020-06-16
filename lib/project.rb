# Created: 2020-05-28
# Revised: 2020-06-15

require_relative 'common_project_task'

 # TODO test tasks/do implementaiton @tasks

class Project < CommonProjectTask
  attr_accessor_with_logging :keyword, :life_context, :psm
  attr_reader :tasks, :tags

  def initialize(title, keyword, life_context = :personal)  # Project
    super(title)
    @keyword = keyword.to_sym
    @life_context = life_context.to_sym
    @tags = Array.new
    @psm = ""
    @tasks = Array.new
  end

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

  def add_task(task)
  end

  def delete_task(task)
  end

  def task_count
    @tasks.count
  end 
  
  # def remove_task(task) ? If you need to move a task from project A to project B..
  # what about an explicit move command instead? Let the data layer handle the mucking about.
  
  def complete_task(task)
  
  end

  def view_project
    puts self # use to_s
    puts "Notes:"
    notes.each { |n| puts " #{n[0].strftime($time_formatting_string)} #{n[1]}"}
   tasks.each { |t| puts(' ',t) }
  end 
  
  def to_s
    if @tags.empty?
      "(#{@keyword}) [#{@life_context}] #{@title}"
    else
      "(#{@keyword}) [#{@life_context}] {#{@tags}} #{@title}"
    end 
  end 
end

