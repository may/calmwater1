# Created: 2020-06-03
# Revised: 2020-06-06

class Habit
  attr_reader :title, :keyword, :trigger, :completion
  
  def initialize(title, keyword, trigger)
    @title = title
    @keyword = keyword
    @trigger = trigger
    @completion = Array.new
    @creation = Time.now
    
  end

  def completed
    @completion << Time.now
  end

  def compliance
    days = ((Time.now - @creation) / (60*60*24)).round
    puts days
    if days == 0
      100
    else
      (completion.count / days.to_f)*100
    end
  end

  def info
    "#{title}\n#{keyword}\n#{trigger}\n#{compliance}%"
  end 

  def brief_info
    "(#{keyword}) [#{compliance}%] #{title}"
  end 
  
end
