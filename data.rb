# Created: 2020-05-28
# Revised: 2020-05-29

require 'yaml'

## TODO $projects_and_tasks

=begin
multiline comment
is like this
=end


# store in arrays by keyword so maybe hash tables?
# potiental issue of syncing keyword in object w/ stored keyword in hash? Or simply don't duplicate?

class Project
  def initialize(title, keyword, life_context)
    @title = title
    @keyword = keyword
    @life_context = life_context
  end


  
  def to_s
    "hello I'm a project"
  end
end

test = Project.new("test project","tp","personal")
puts test

class Task
end

#class generic-project-task
#end

m = YAML.load(File.read('yaml.dump'))
# m = File.open('/marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }

m = [1, 2, 3, 4, "Ruby"]

#sleep 0.9

#File.open('yaml.dump', 'w') { |f| f.write(YAML.dump(m)) }
#File.open('marshal.dump', 'wb') { |f| f.write(Marshal.dump(m)) }
