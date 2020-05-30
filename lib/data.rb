# Created: 2020-05-28
# Revised: 2020-05-29

require 'yaml'

$time_formatting_string = "%Y-%m-%d %H:%M, %A."


## TODO $projects_and_tasks

=begin
multiline comment
is like this
=end


# store in arrays by keyword so maybe hash tables?
# potiental issue of syncing keyword in object w/ stored keyword in hash? Or simply don't duplicate?

class Project
  def Project.attr_accessor_with_logging(*names)
    attr_reader(*names)
    names.each do |name|
      define_method :"#{name}=" do |v|
        current_instance_variable = instance_variable_get(:"@#{name}")
        add_note("Updated #{name}:\n old: #{current_instance_variable}\n new: #{v}")
        instance_variable_set(:"@#{name}", v)
      end
    end
  end 

 # TODO test tags/do implementaiton @tags
 # TODO test tasks/do implementaiton @tasks
 # TODO test/do implementaiton @psm
 # TODO test /do implementaiton @completed
 # TODO test /do implementaiton @deleted
  
  attr_accessor :modified
  attr_accessor_with_logging :title, :keyword, :tags, :tasks, :psm, :completed, :deleted, :reviewed
  attr_reader :notes, :created
  
  def initialize(title, keyword, life_context)
    now = Time.now
    @title = title
    @keyword = keyword
    @life_context = life_context
    @notes = Array.new
    @notes.unshift([now,"Created: #{title}"])
    @created = now
    @modified = now
    @reviewed = now
    @tags = Array.new
    @psm = ""
    @completed = nil
    @deleted = nil
  end

  def add_note(note_text)
    # Add notes to front of array, so that they are stored in reverse chronological order.
    @notes.unshift([Time.now,note_text])
  end

  def complete
    @completed = Time.now
    add_note("Task completed.")
  end

  def completed?
    !!@completed
  end
  
  def  
    
    
    def to_s
      "hello I'm a project"
    end
  end

  =begin
     ## manual testing
     test = Project.new("test project","tp","personal")
     test.add_note("called john")
     test.add_note("called john2")
     test.add_note("called john3")
     #puts test.notes
     p test.notes
     if test.title == "test project"
       puts "ok"
     else
       "not ok"
     end 
     test.title = "new title"
     puts test.title
     =end


  class Task
  end

  #class generic-project-task
  #end

  #m = YAML.load(File.read('yaml.dump'))
  # m = File.open('/marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

  #m = [1, 2, 3, 4, "Ruby"]

  #sleep 0.9

  #File.open('yaml.dump', 'w') { |f| f.write(YAML.dump(test)) }
  #File.open('marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

