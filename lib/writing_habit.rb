# Created: 2020-06-11
# Revised: 2020-06-13
# From extbrain command line, ideally invoke this as:
# h wc Write every day, one word more than the last day.
# But do whatever works best for you for a habit title!
# Then use h wc 500 each day after writing where 500 is
#  the total word count of your current document.

class WritingHabit < Habit
  attr_reader :average_word_count, :previous_word_count
  
  def initialize(title, keyword, trigger)
    super(title, keyword, trigger)
    @previous_word_count = 0
    @average_word_count = 0
    @word_count_over_time = Array.new
  end

  def completed(todays_total_word_count)
    @completion << Time.now
    todays_total_word_count = todays_total_word_count.to_i
    words_written_today = todays_total_word_count - @previous_word_count
    if words_written_today.positive?
      @word_count_over_time << [words_written_today,Time.now]
    else
      # negative means we started a new story eg 100 words minus old count of 5000
      @word_count_over_time << [todays_total_word_count.to_i,Time.now]
    end
    @previous_word_count = todays_total_word_count
    update_average
  end
  
  def update_average
    @average_word_count = (@word_count_over_time.sum { |wc_pair| wc_pair.first })/@word_count_over_time.count
  end

  # Eg when the writer wants to know how much they wrote today!
  def latest_word_count
    @word_count_over_time.last.first
  end 
  
  def to_s
    # Write every day, one word more than the last day (on average).
    # Credit jamesclear.com/measure-backward
    if $color_only # let color coding in extbrain_data handle last completed
      # 1.0
      #  "(#{keyword}) [#{compliance}%] {Next session: #{@average_word_count}+1=#{@average_word_count+1}} #{title}"
      next_session = @average_word_count + 1
    "(#{keyword}) [#{compliance}%] {Next session: #{next_session}, #{@previous_word_count + next_session} total} #{title}"
    else
      # 1.0
      # "(#{keyword}) [#{compliance}%] (#{last_completed}) {Next session: #{@average_word_count}+1=#{@average_word_count+1}} #{title}"
    end 
  end 
  
end
