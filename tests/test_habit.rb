# Created: 2020-06-03
# Revised: 2024-02-24

require_relative '../lib/habit.rb'

require 'minitest/autorun'
require 'minitest/pride'

class HabitTest < Minitest::Test
  def setup
    @h = Habit.new("bike nightly", "bike")#, "clock hits 20:00")
  end

  def test_completed
    assert_equal([],@h.completion)
    @h.completed
    assert_equal(Time.now.to_i,@h.completion.first.to_i)
  end

  def test_trigger
    assert_equal("clock hits 20:00",@h.trigger)
  end 

  def test_trigger
    assert_equal("bike nightly",@h.title)
  end 

end 
