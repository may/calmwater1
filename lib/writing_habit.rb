# Created: 2020-06-11
# Revised: 2021-02-03
# From extbrain command line, ideally invoke this as:
# h wc Write every day, one word more than the last day.
# But do whatever works best for you for a habit title!
# Then use h wc 500 each day after writing where 500 is
#  the total word count of your current document.

class WritingHabit < Habit
  attr_reader :average_word_count, :previous_word_count
  
  def initialize(title, keyword)
    super(title, keyword)
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
    # Zero refers to days you didn't write, eg your word count was zero.
    if $use_zero_day_average
      seconds_since_creation = Time.now - @creation
      days_since_creation = seconds_since_creation / (24 * 60 * 60)
      @average_word_count = (@word_count_over_time.sum { |wc_pair| wc_pair.first })/days_since_creation.round
    else
      @average_word_count = (@word_count_over_time.sum { |wc_pair| wc_pair.first })/@word_count_over_time.count
    end
  end

  # Eg when the writer wants to know how much they wrote today!
  def latest_word_count
    @word_count_over_time.last.first
  end 
  
  def to_s
    # Write every day, one word more than the last day (on average).
    # Credit jamesclear.com/measure-backward
    next_session = @average_word_count + 1
    if $color_only # let color coding in extbrain_data handle last completed
      "(#{keyword}) [#{compliance}%] {Next session: #{next_session}, #{@previous_word_count + next_session} total} #{title}"
    else
      "(#{keyword}) [#{compliance}%] (#{last_completed}) {Next session: #{next_session}, #{@previous_word_count + next_session} total} #{title}"
    end 
  end 
end
