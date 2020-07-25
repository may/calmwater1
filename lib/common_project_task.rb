# Created: 2020-05-28
# Revised: 2020-07-25
# Used by Projects and Tasks.

class CommonProjectTask
  def CommonProjectTask.attr_accessor_with_logging(*names)
    attr_reader(*names)
    names.each do |name|
      define_method :"#{name}=" do |v|
        current_instance_variable = instance_variable_get(:"@#{name}")
        add_note("Updated #{name}:\n old: #{current_instance_variable}\n new: #{v}")
        instance_variable_set(:"@#{name}", v)
      end
    end
  end

  attr_accessor_with_logging :title, :life_context
  attr_reader :notes, :created, :completed, :deleted, :last_reviewed

  def initialize(title,life_context)
    @title = title
    @life_context = life_context.to_sym 
    @notes = Array.new
    add_note("Created: #{title}")
    @created = Time.now
    @completed = nil
    @deleted = nil
    # Explicitly set this to nil, because it isn't technically reviewed
    # upon creation; it's just created - possibly with little thought!
    # But that's OK; dump it in extbrain, review it later.
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

  def uncomplete
    @completed = nil
    add_note("#{self.class.name} UNcompleted.")
  end

  def completed?
    # !! is not not, to force boolean
    !!@completed
  end

  def delete
    @deleted = Time.now
    add_note("#{self.class.name} deleted.")
  end

  def undelete
    @deleted = nil
    add_note("#{self.class.name} UNdeleted.")
  end

  def deleted?
    !!@deleted
  end

  def reviewed
    @last_reviewed = Time.now
    add_note("#{self.class.name} reviewed.")
  end

  def view_notes
        puts " Notes:"
        @notes.each do |n|
          puts "  #{n[0].strftime($time_formatting_string)}"
          n[1].lines.each { |note_line| puts "    #{note_line}" }
        end 
  end
end
