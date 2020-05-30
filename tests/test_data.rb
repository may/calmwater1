require_relative '../lib/data'
require 'minitest/autorun'
require 'minitest/pride'

class ProjectTest < Minitest::Test
  def setup
    @test = Project.new("test project","tp","personal")
    @now = @test.created
  end

  def test_title
    assert_equal("test project",@test.title)
    @test.title = "new title"  
    assert_equal("new title",@test.title)
    assert_equal("Updated title:\n old: test project\n new: new title",@test.notes.first.last)
  end 

  def test_keyword
    assert_equal("tp",@test.keyword)
    @test.keyword = "toiletpaper"
    assert_equal("toiletpaper",@test.keyword)
    assert_equal("Updated keyword:\n old: tp\n new: toiletpaper",@test.notes.first.last)
  end

  def test_add_note
    @test.add_note("called fence company")
    assert_equal("called fence company",@test.notes.first.last)
    @test.add_note("called Internet company re: faster Internet")
    assert_equal("called Internet company re: faster Internet",@test.notes.first.last)
    assert_equal("called fence company",@test.notes[1].last)
    assert_equal("Created: test project",@test.notes.last.last)
    assert_equal(@now.to_i,@test.notes.last.first.to_i)
  end

=begin  
  # Test passes, but not sure I need modified. 2020-05-30.
  def test_modified
      @test.modified = @now
      @test.modified = Time.new(2020, 05, 29, 17, 9)
      assert_equal(Time.new(2020, 05, 29, 17, 9).to_i,@test.modified.to_i)
  end 
=end
  
  def test_reviewed
    assert_nil(@test.last_reviewed)
    now = Time.now
    @test.reviewed
    assert_equal(now.to_i,@test.last_reviewed.to_i)
    assert_equal("Task reviewed.",@test.notes.first.last)
  end     

  # s/m test_created. would have to find a better way to set @now haha.

  def test_tags
    assert_equal([],@test.tags)
    @test.tags = %w{ house yard }
    assert_equal(%w{ house yard },@test.tags)
  end
  
  def test_tasks
  end
  
  def test_psm
    @test.psm = "test project support material"
    assert_equal("test project support material",@test.psm)
    @test.psm = "new, better, shorter psm"
    assert_equal("Updated psm:\n old: test project support material\n new: new, better, shorter psm",@test.notes.first.last)
  end

  def test_completed
    assert_nil(@test.completed)
    refute(@test.completed?) # refute is what we say when we want assert_false
    @test.complete
    assert(@test.completed?)
    assert_equal(Time.now.to_i,@test.completed.to_i)
    assert_equal("Task completed.",@test.notes.first.last)
  end
  
  def test_deleted
    assert_nil(@test.deleted)
    refute(@test.deleted?)
    @test.delete
    assert(@test.deleted?)
    assert_equal(Time.now.to_i,@test.deleted.to_i)
    assert_equal("Task deleted.",@test.notes.first.last)
  end

  # todo respond to project-object.deleted? 
  
end 
