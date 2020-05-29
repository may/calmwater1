require_relative '../lib/data'
require 'minitest/autorun'
class ProjectTest < Minitest::Test
  def setup
    @test = Project.new("test project","tp","personal")
  end
  
  def test_title
    assert_equal(@test.title, "test project")
    @test.title = "new title"  
    assert_equal(@test.title, "new title")
  end 

  def test_keyword
    assert_equal(@test.keyword,"tp")
  end 

end 
