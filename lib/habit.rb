# Created: 2020-06-03
# Revised: 2020-06-18

# TODO consider a rename habit function that also dumps previous name into notes field like tasks/projects do.
# 2020-06-18- did add a notes field that I'm just maintaining manually for any thing like this for now

class Habit
  attr_reader :title, :keyword, :trigger, :completion
  
  def initialize(title, keyword, trigger)
    @title = title
    @keyword = keyword
    @trigger = trigger
    @completion = Array.new
    @creation = Time.now
    @notes = ""
  end

  def rename(new_title)
    add_note("old title: #{@title}")
    @title = new_title
  end 
  
  def add_note(contents)
    @notes << contents
  end 
  
  def completed(optional = nil) # optional exists b/c of WritingHabit... not perfect encapsulation
    @completion << Time.now
  end

  def compliance
    days = ((Time.now - @creation) / (60*60*24)).round
    if days == 0
      100
    else
      ((completion.count / days.to_f)*100).round
    end
  end

  def completed_today?
    @completion.last.mday == Time.now.mday 
  end

  def completed_yesterday?
    (@completion.last.mday + 1) == Time.now.mday
  end

  def completed_two_days_ago?
    (@completion.last.mday + 2) == Time.now.mday
  end

  def last_completed_date
    @completion.last.strftime('%Y-%m-%d')
  end 

  def last_completed
    if completed_today?
      'today'
    elsif completed_yesterday?
      'yesterday'
    elsif completed_two_days_ago?
      'two days ago'
    else
      last_completed_date
    end
  end
  
  def to_s
    # this works b/c attr_reader/method call
    if $color_only # let color coding in extbrain_data handle last completed 
      "(#{keyword}) [#{compliance}%] #{title}"
    else
      "(#{keyword}) [#{compliance}%] (#{last_completed}) #{title}"
    end 
  end 
  
end
