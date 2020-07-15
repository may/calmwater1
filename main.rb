# Created: 2020-05-30
# Revised: 2020-07-15


# todo d for delete
# I think r for rename
# and plc for project life context change
# the editor is NOT modal
# so no 'ep' for edit projects where yo uselect a value
# you have to know what the command is
# not usefr friendly
# but ? should also yield a handy command list, stored in main,rb 
# todo
# r for rename task, or e for edit, or ep for edit project?

require_relative 'lib/controller'
require_relative 'config.rb'

$writing_mode = false

$help_text = <<HEREDOC
TODO consider scanning source code for each function and documenting but that seems silly
just keep it all here and extract from this text to the readme
p project
etc. todo help text
HEREDOC



def startup
  $data = ExtbrainData.new
end

at_exit do
  if $lockfile_locked
    puts "Can't get lock... exiting.."
  else
    $data.save_data(true) # save and clear lock
    puts "Thank you for using extbrain. Have a good day!"
  end 
end



def command_loop
  $no_operation_count = 0
  while true
    $writing_mode ? print("wm> ") : print("> ")
    input = gets
    # TODO try $data.load_data BEFORE modyiftgin state.
    # TODO scope lockfile to just save load
    dispatch_user_input(input)
    $data.save_data
  end 
end

def dispatch_user_input(input_string)
  input_string.rstrip! # remove trailing whitespace, which is at minimum a newline
  if $writing_mode
    unless 'exit' == input_string or '!!' == input_string
      writing_mode_input(input_string)
    else
      disable_writing_mode
    end
  else
    three_pieces = input_string.split(' ',3)
    command = three_pieces[0]
    keyword = three_pieces[1]
    content = three_pieces[2]
    case command
    # TODO TODO pt to add tags to projects, or just replace specify a new space seprated list?
    # TODO plc keyword context edit context
    #   # lpw or wp = work projects
  # lph = home projects
  # lpp = personal projects
  # li / lm = list info (or metadata) with optional keyword for specific project


        ## TODO if 'clear' send 'clear' to terminal? tput clear??
    when '!!', 'wm'
      enable_writing_mode
    #MAYBE if you want multi-word searching add content and keyword
    when 'c', 'complete', 'finish', 'done'
      complete_or_delete_task_or_project(keyword, true)
    when 'e', 'exit', 'q'
      exit
    when 'h', 'habit'
      habit_input(keyword, content)
    when 'lt', 'list-tasks'
      task_list(keyword)
    when 'lw'
      task_list('work')
    when 'lc'
      task_list('computer')
      # TODO when lw work, lcomputer, lerrands, lagenda?
    when 'p', 'proj', 'project', 'projects', 'lp'
      project_input(keyword, content)
    when 'pt', 'project-task'
      project_task(keyword, content)
    when 'pe', 'project-edit'
      project_edit(keyword, content)
    when 's', 'search'
      search(keyword)
    when 't', 'task'
      task_input(keyword, content)
    when '?', 'help'
      puts $help_text
    else
      # todo reset no op once the user inputs a command correctly?
      no_op_msg = "That doesn't do anything." # At least not yet.
      if $no_operation_count > 22
        puts "You clearly have no idea what's going on. Let me fix that... exiting..."
        exit
      elsif $no_operation_count > 20
        puts "Step away from the keyboard, please!"
      elsif $no_operation_count > 15
        puts "Step away from the keyboard, please."
      elsif $no_operation_count > 13
        puts "Step away from the keyboard."
      elsif $no_operation_count > 7
        puts "You should go outside."
      elsif $no_operation_count > 3
        puts no_op_msg
        puts "Maybe take a break?"
      else
        puts no_op_msg
      end 
      $no_operation_count += 1
    end 
  end
end






# Once development finished, update this to 0.2 "testing", with a fixed date
puts "Welcome to extbrain, version 0.1 (\"prototype\"), #{Time.now.strftime('%Y-%m-%d')}"
startup
command_loop

