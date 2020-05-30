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

 # TODO test tasks/do implementaiton @tasks


  # Not sure need modified, since have explict reviewed date. 2020-05-30 
  # IF we do have modified, need to make sure it gets updated whenever ANYTHING
  # on the Project is touched, which requires more coding/custom assessor and readers.
  #  attr_accessor :modified
  attr_accessor_with_logging :title, :keyword, :tags, :psm, :life_context
  attr_reader :notes, :tasks, :created, :completed, :deleted, :last_reviewed
  
  def initialize(title, keyword, life_context)
    now = Time.now
    @title = title
    @keyword = keyword
    @life_context = life_context.to_sym
    @created = now
    @notes = Array.new
    @notes.unshift([now,"Created: #{title}"])

#    @modified = now
    @last_reviewed = nil
    @tags = Array.new
    @psm = ""
    @completed = nil
    @deleted = nil
  end

  def add_note(note_text)
    # Add notes to front of array, so that they are stored in reverse chronological order.
    @notes.unshift([Time.now,note_text])
  end

  def add_task
  end

  def complete_task
  end

  def delete_task
  end

  # TODO factor these out into shared class
  def complete
    @completed = Time.now
    add_note("#{self.class.name} completed.")
  end

  def completed?
    # !! is not not, to force boolean
    !!@completed
  end

  def delete
    @deleted = Time.now
    add_note("#{self.class.name} deleted.")
  end

  def deleted?
    !!@deleted
  end

  def reviewed
    @last_reviewed = Time.now
    add_note("#{self.class.name} reviewed.")
  end
  
  def to_s
    "hello I'm a project TODO"
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

  #class project-task-common
  #end

  #m = YAML.load(File.read('yaml.dump'))
  # m = File.open('/marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

  #m = [1, 2, 3, 4, "Ruby"]

  #sleep 0.9

  #File.open('yaml.dump', 'w') { |f| f.write(YAML.dump(test)) }
  #File.open('marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

