# Created: 2020-05-30
# Revised: 2020-05-30

require_relative 'common_project_task'

class Task < CommonProjectTask
  attr_reader :action_context
  
  def initialize(title, action_context, life_context = :personal)
    super(title)
    @action_context = action_context
    @life_context = life_context.to_sym 
  end
end



