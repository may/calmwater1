# Created: 2020-05-28
# Revised: 2020-05-29

require 'yaml'

@@time_formatting_string = "%Y-%m-%d %H:%M, %A."


## TODO $projects_and_tasks

=begin
multiline comment
is like this
=end


# store in arrays by keyword so maybe hash tables?
# potiental issue of syncing keyword in object w/ stored keyword in hash? Or simply don't duplicate?

class Project
  attr_accessor :title, :keyword, :modified, :last_reviewed
  attr_reader :notes, :created
  def initialize(title, keyword, life_context)
    now = Time.now
    @title = title
    @keyword = keyword
    @life_context = life_context
    @notes = Array.new
    @notes.unshift([now,"Created: #{title}"])
    @created = now
  end

  def add_note(note_text)
    # Add notes to front of array, so that they are stored in reverse chronological order.
    @notes.unshift([Time.now,note_text])
  end

  def to_s
    "hello I'm a project"
  end
end

## manual testing
test = Project.new("test project","tp","personal")
test.add_note("called john")
test.add_note("called john2")
test.add_note("called john3")
puts test.notes
p test.notes
if test.title == "test project"
  puts "ok"
else
  "not ok"
end 

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
