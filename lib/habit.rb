# Created: 2020-06-03
# Revised: 2020-11-14

# TODO BUGFIX - switch from Time to DateTime to allow proper yesterday & two days ago detection
# across month boundries

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
    @deleted = false
  end

  def deleted?
    !!@deleted
  end
  
  def delete!
    @deleted = true
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
      @completion.last.yday == Time.now.yday
    end
  end

  def completed_yesterday?
    unless @completion.empty?
#      ((@completion.last.to_i - 18000) / 86400.0).floor == Time.now.to_i.floor
      (@completion.last.yday + 1) == Time.now.yday
    end
  end

  def completed_two_days_ago?
    unless @completion.empty?
      #((@completion.last.to_i - 18000) / 86400.0).floor == Time.now.to_i.floor
       (@completion.last.yday + 2) == Time.now.yday
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
    # if you read this later and wonder how, this works b/c attr_reader/method call
    if $color_only # let color coding in extbrain_data handle last completed 
      "(#{keyword}) [#{compliance}%] #{title}"
    else
      "(#{keyword}) [#{compliance}%] (#{last_completed}) #{title}"
    end 
  end 
  
end
