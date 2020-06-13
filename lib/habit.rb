# Created: 2020-06-03
# Revised: 2020-06-12

class Habit
  attr_reader :title, :keyword, :trigger, :completion
  
  def initialize(title, keyword, trigger)
    @title = title
    @keyword = keyword
    @trigger = trigger
    @completion = Array.new
    @creation = Time.now
  end

  def completed(optional = nil) # optional exists b/c of WritingHabit... not perfect encapsulation
    @completion << Time.now
  end

  def compliance
    days = ((Time.now - @creation) / (60*60*24)).round
    if days == 0
      100
    else
      (completion.count / days.to_f)*100
    end
  end

  def info
    "#{title}\n#{keyword}\n#{trigger}\n#{compliance}%"
  end 

  def to_s
    puts completion.last
    puts completion.last.mday
    puts Time.now.mday
    if @completion.last.mday == Time.now.mday
      last_completed = 'today'
    elsif (@completion.last.mday + 1) == Time.now.mday
      last_completed = 'yesterday'
    end 
    # todo if logged today or yesterday say that else blank
    # this works b/c attr_reader/method call
    "#{last_completed} (#{keyword}) [#{compliance}%] #{title}"
  end 
  
end
