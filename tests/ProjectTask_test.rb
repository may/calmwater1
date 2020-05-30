require_relative '../lib/data'
require 'minitest/autorun'
require 'minitest/pride'

class ProjectAndTaskTest < Minitest::Test
  def setup
    @test_project = Project.new("test project","tp","family")
    @now = @test_project.created
  end

  def test_title
    assert_equal("test project",@test_project.title)
    @test_project.title = "new title"  
    assert_equal("new title",@test_project.title)
    assert_equal("Updated title:\n old: test project\n new: new title",@test_project.notes.first.last)
  end 

  def test_keyword
    assert_equal("tp",@test_project.keyword)
    @test_project.keyword = "toiletpaper"
    assert_equal("toiletpaper",@test_project.keyword)
    assert_equal("Updated keyword:\n old: tp\n new: toiletpaper",@test_project.notes.first.last)
  end

  def test_add_note
    @test_project.add_note("called fence company")
    assert_equal("called fence company",@test_project.notes.first.last)
    @test_project.add_note("called Internet company re: faster Internet")
    assert_equal("called Internet company re: faster Internet",@test_project.notes.first.last)
    assert_equal("called fence company",@test_project.notes[1].last)
    assert_equal("Created: test project",@test_project.notes.last.last)
    assert_equal(@now.to_i,@test_project.notes.last.first.to_i)
  end

  def test_project_life_context
    assert_equal(:family,@test_project.life_context)
    @test_project.life_context = :work
    assert_equal(:work,@test_project.life_context)
    assert_equal("Updated life_context:\n old: family\n new: work",@test_project.notes.first.last)
    # I don't like having the underscore in life_context when writing to
    # something the user may see, but updating this should be rare enough
    # that I can live with it. Plus less code = better, and I don't want to
    # create a specific handler just for this.
  end
  
  def test_project_without_life_context
    p2 = Project.new("some title", "some keyword but no life context you notice")
    assert_equal(:personal,p2.life_context)
  end
  
  def test_project_tags_is_array
    assert_equal([],@test_project.tags)
  end
  
  def test_project_tags
    assert_empty(@test_project.tags)
    # %i is shortcut for symbols
    @test_project.tags = %i{ house yard }
    assert_equal(%i{ house yard },@test_project.tags)
  end

  def test_project_tags_single_string
    assert_empty(@test_project.tags)
    @test_project.tags = "single-string"
    assert_equal([:"single-string"], @test_project.tags)  
  end

  def test_project_tags_several_strings
    assert_empty(@test_project.tags)
    # %i is shortcut for symbols
    @test_project.tags = %w{ one two three }
    assert_equal(%i{ one two three }, @test_project.tags)
  end

  def test_project_tags_single_symbol_tag
    assert_empty(@test_project.tags)
    @test_project.tags = :tag_test 
    assert_equal([:tag_test], @test_project.tags)
  end

  def test_project_tags_wrong
    assert_output("Hey! Your tags weren't a symbol, array or string, so no promises things will work. Data saved though..\n") { @test_project.tags = 1234 }


  end
=begin  
  # Test passes, but not sure I need modified. 2020-05-30.
  def test_modified
      @test_project.modified = @now
      @test_project.modified = Time.new(2020, 05, 29, 17, 9)
      assert_equal(Time.new(2020, 05, 29, 17, 9).to_i,@test_project.modified.to_i)
  end 
=end
  
  def test_project_reviewed
    assert_nil(@test_project.last_reviewed)
    now = Time.now
    @test_project.reviewed
    assert_equal(now.to_i,@test_project.last_reviewed.to_i)
    assert_equal("Project reviewed.",@test_project.notes.first.last)
  end     

  # s/m test_created. would have to find a better way to set @now haha.

  
  def test_tasks
  end
  
  def test_project_psm
    @test_project.psm = "test project support material"
    assert_equal("test project support material",@test_project.psm)
    @test_project.psm = "new, better, shorter psm"
    assert_equal("Updated psm:\n old: test project support material\n new: new, better, shorter psm",@test_project.notes.first.last)
  end

  def test_project_completed
    assert_nil(@test_project.completed)
    refute(@test_project.completed?) # refute is what we say when we want assert_false
    @test_project.complete
    assert(@test_project.completed?)
    assert_equal(Time.now.to_i,@test_project.completed.to_i)
    assert_equal("Project completed.",@test_project.notes.first.last)
  end
  
  def test_project_deleted
    assert_nil(@test_project.deleted)
    refute(@test_project.deleted?)
    @test_project.delete
    assert(@test_project.deleted?)
    assert_equal(Time.now.to_i,@test_project.deleted.to_i)
    assert_equal("Project deleted.",@test_project.notes.first.last)
  end

end 
