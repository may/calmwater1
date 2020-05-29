require_relative '../lib/data'
require 'minitest/autorun'
require 'minitest/pride'

class ProjectTest < Minitest::Test
  def setup
    @test = Project.new("test project","tp","personal")
    @now = Time.now
  end
  
  def test_title
    assert_equal(@test.title, "test project")
    @test.title = "new title"  
    assert_equal(@test.title, "new title")
  end 

  def test_keyword
    assert_equal(@test.keyword,"tp")
  end

  def test_add_note
    @test.add_note("called fence company")
    assert_equal(@test.notes[0],"called fence company")
    @test.add_note("called Internet company re: faster Internet")
    assert_equal(@test.notes[0],"called Internet company re: faster Internet")
    assert_equal(@test.notes[1],"called fence company")
    assert_equal(@test.notes.last,"Created: #{@now.strftime(@@time_formatting_string)}")

  end 
end 
