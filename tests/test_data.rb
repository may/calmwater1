require_relative '../lib/data'
require 'minitest/autorun'
require 'minitest/pride'

class ProjectTest < Minitest::Test
  def setup
    @test = Project.new("test project","tp","personal")
    @now = @test.created
  end
  
  # Time stuff first b/c miliseconds matter and I'm too lazy to do it right
# https://stackoverflow.com/questions/35804038/how-can-i-make-this-time-assertion-match-perfectly-with-either-time-date-or-da  

  # TODO TODO TODO
  # make it assert_equal EXPECTED actual
  # so like STRING then CHECK VARIBLE VALUE
  
  def test_add_note
    @test.add_note("called fence company")
    assert_equal("called fence company",@test.notes.first.last)
    @test.add_note("called Internet company re: faster Internet")
    assert_equal("called Internet company re: faster Internet",@test.notes.first.last)
    assert_equal("called fence company",@test.notes[1].last)
    assert_equal("Created: test project",@test.notes.last.last)
    assert_equal(@now.to_i,@test.notes.last.first.to_i)
  end

  def test_modified
      @test.modified = @now
      @test.modified = Time.new(2020, 05, 29, 17, 9)
      assert_equal(Time.new(2020, 05, 29, 17, 9).to_i,@test.modified.to_i)
  end 

  #todo last reviewed should log notes too
  def test_reviewed
    assert_equal(@now.to_i,@test.reviewed.to_i)
    fixed_time = Time.new(2020, 05, 30, 11, 12)
    @test.reviewed = fixed_time
    assert_equal(fixed_time.to_i,@test.reviewed.to_i)
    assert_equal("Updated reviewed:\n old: #{@now}\n new: #{fixed_time}",@test.notes.first.last)
  end     

  # End time stuff

  def test_title
    assert_equal(@test.title, "test project")
    @test.title = "new title"  
    assert_equal(@test.title, "new title")
    assert_equal("Updated title:\n old: test project\n new: new title",@test.notes.first.last)
  end 


  def test_keyword
    assert_equal(@test.keyword,"tp")
    @test.keyword = "toilet-paper"
    assert_equal(@test.keyword,"toilet-paper")
    assert_equal("Updated keyword:\n old: tp\n new: toilet-paper",@test.notes.first.last)
  end


  
  def test_tags
  end 
  def test_tasks
  end
  def test_psm
#    @test.psm = "test project support material"
#    assert_equal(@test.psm,"test project support material")
#    @test.psm = "new, better, shorter psm"
  #    assert_equal(@test.notes.first.last, "Updated psm:\n old: test project support material\n new: new, better, shorter psm")
  end
end 
