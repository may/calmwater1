# Created: 2020-06-03
# Revised: 2020-06-23

# TODO consider a rename habit function that also dumps previous name into notes field like tasks/projects do.
# 2020-06-19 for now sticking with just deleting/depracating habits as needed
# 2020-06-19 can't add a notes field manually in the yaml I learned haha

class Habit
  attr_reader :title, :keyword, :trigger, :completion
  
  def initialize(title, keyword, trigger)
    @title = title
    @keyword = keyword
    @trigger = trigger
    @completion = Array.new
    @creation = Time.now
  end
  
  def completed(optional = nil)
    if optional
      @completion << Time.now-86400 # 86400 = 1 day of seconds; 60*60*24
    else 
      @completion << Time.now
    end 
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
    unless @completion.empty?
      @completion.last.mday == Time.now.mday
    end
  end

  def completed_yesterday?
    unless @completion.empty?
      if (@completion.last.mday + 1) == Time.now.mday
        true
      elsif @completion.last.mday > Time.now.mday # month rolls over
        true
      else
        false
    end
  end

  def completed_two_days_ago?
    unless @completion.empty?
      (@completion.last.mday + 2) == Time.now.mday
    end
  end

  def last_completed_date
    unless @completion.empty?   
      @completion.last.strftime('%Y-%m-%d')
    end
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
