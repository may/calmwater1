# Created: 2020-05-30
# Revised: 2020-07-03

require_relative 'common_project_task'

class Task < CommonProjectTask
  attr_reader :action_context
  
  def initialize(title, action_context, life_context = :personal)
    super(title)
    @action_context = action_context
    @life_context = life_context.to_sym 
  end

  def to_s(inside_project)
    if inside_project # project already has life context
      "(#{action_context}) #{@title}"
    else
      "[#{life_context}] (@#{action_context}) #{@title}"
    end 
  end
end



