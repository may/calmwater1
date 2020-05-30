# Created: 2020-05-28
# Revised: 2020-05-30

require 'yaml'

$time_formatting_string = "%Y-%m-%d %H:%M, %A."

## TODO $projects_and_tasks


# store in arrays by keyword so maybe hash tables?
# potiental issue of syncing keyword in object w/ stored keyword in hash? Or simply don't duplicate?

class ProjectTaskCommon
  def ProjectTaskCommon.attr_accessor_with_logging(*names)
    attr_reader(*names)
    names.each do |name|
      define_method :"#{name}=" do |v|
        current_instance_variable = instance_variable_get(:"@#{name}")
        add_note("Updated #{name}:\n old: #{current_instance_variable}\n new: #{v}")
        instance_variable_set(:"@#{name}", v)
      end
    end
  end

  # Not sure need modified, since have explict reviewed date. 2020-05-30 
  # IF we do have modified, need to make sure it gets updated whenever ANYTHING
  # on the Project is touched, which requires more coding/custom assessor and readers.
  #  attr_accessor :modified
  
  attr_accessor_with_logging :title
  attr_reader :notes, :created, :completed, :deleted, :last_reviewed

  def initialize(title) # ProjectTaskCommon
    @title = title
    @notes = Array.new
    add_note("Created: #{title}")
    @created = Time.now
#    @modified = Time.now
    @completed = nil
    @deleted = nil
    # Explicitly set this to nil, because it isn't technically reviewed
    # upon creation; it's just created - possibly with little thought! :-D
    # But that's OK; dump it in here, review it later.
    @last_reviewed = nil
  end

  def add_note(note_text)
    # Add notes to front of array, so that they are stored in reverse
    # chronological order. This will make it easy later to always display
    # the latest note; notes[].
    # Of course I could write an accessor for that... .latest_note meh.. s/m.
    @notes.unshift([Time.now,note_text])
  end

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

end
 # TODO test tasks/do implementaiton @tasks

class Project < ProjectTaskCommon
  attr_accessor_with_logging :keyword, :life_context, :psm
  attr_reader :tasks, :tags

  def initialize(title, keyword, life_context = :personal)  # Project
    super(title)
    @keyword = keyword # s/m make a symbol?
    @life_context = life_context.to_sym
    @tags = Array.new
    @psm = ""
  end

  # Expects tags to be an array of symbols, but a single symbol is ok too.
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
  def add_task
  end

  def complete_task
    # should this exisst on project? no
  end

  def delete_task
  end

  # TODO factor these out into shared class
  
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

