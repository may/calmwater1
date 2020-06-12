# Created: 2020-06-11
# Revised: 2020-06-11
# From extbrain command line, ideally invoke this as:
# h wc Write every day, one word more than the last day.
# But do whatever works best for you for a habit title!

class WritingHabit < Habit
  def initialize(title, keyword, trigger)
    super(title, keyword, trigger)
    @word_count = 0
    @word_count_over_time = Array.new
  end

  def completed(todays_word_count)
    @completion << Time.now
    @word_count = todays_word_count.to_i
    @word_count_over_time << [Time.now,todays_word_count]
  end
  
  def info
    "#{title}\n#{keyword}\n#{trigger}\n#{compliance}%\n#{todays_word_count}"
  end 

  def to_s
    # Write every day, one word more than the last day.
    # Credit jamesclear.com/measure-backward
    "(#{keyword}) [#{compliance}%] {Tomorrow: #{@word_count}+1=#{@word_count+1}} #{title}"
  end 
  
end
