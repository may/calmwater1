# Created: 2020-05-30
# Revised: 2021-10-31


# todo d for delete
# I think r for rename
# the editor is NOT modal
# so no 'ep' for edit projects where yo uselect a value
# you have to know what the command is
# not usefr friendly
# but ? should also yield a handy command list, stored in main,rb 
# todo
# r for rename task, or e for edit, or ep for edit project?

require_relative 'lib/controller'
require_relative 'config.rb'
require_relative 'tips.rb'

# TODO steal from controller.rb around 393 inside review_and_maybe_edit
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
    File.open("${save_directory}/extbrain_debug_at_exit_cant_get_lock.txt", "w") { "If you see this file, delete it. Then, keep an eye out for ways to reproduce the behavior that created this file. If you can reliably get this file to appear without doing something crazy, open an issue." }
  else
    if $log_command_usage
      if $command_usage
        File.open($data_file_command_usage, 'w') { |f| f.write(YAML.dump($command_usage)) }
        # implicitly changes this to an array, which we don't want, so don't save this, only print
        usage = $command_usage.sort_by { |key, value| -value }
        puts usage.to_h
      end
    end
    # When killing extbrain running in PuTTY over SSH (not mosh) on my Windows work
    # laptop over the VPN, by shutting down the laptop the habits file is lost.
    # Extensive debugging traced it to: unknown factors.
    # In short, we get to the point where we are starting to save data and then
    # everything is killed.
    # The reason the habits file gets wiped is, I believe, simply beause it is the
    # first thing we try to save.
    # And when we start saving, the first thing we do is truncate the existing
    # file to zero, and *then* write data.
    # For now, 2020-12-17, I'm just going to remove the 'save_data' call in at_exit.
    # Because everytime you enter data into extbrain it's saved immediately anyway.
    # But... we need to clear the lock. Frack.
    # Maybe make a clear_lock function?
    # Or detach and self-terminate? Hmm.
    # Honestly, do we *need* to clear the lock? Sure it's nice, but the program
    # is now robust enough to take over a non-cleared lock instead of blocking.
    # Yeah, we're no longer blocking on an uncleared lock, so we'll take data
    # saving and lock clearing out of at_exit, and if it bites us later we can
    # read this then and decide then haha future self!
    # The other catch here is we miss the lovely printing of everything we're saving
    # at time of exit, but oh well. 2020-12-17.
    # todo detect if on mosh or ssh
    # 2020-12-18 learned that we don't clear the lock either.
    #  so added this     File.delete($lockfile)
    #
    # But 2020-12-18, learned that weekly review didn't save if you exited in the middle.
    # So reverting the code to how it was, AND just not killing putty at work if I can..
    $data.save_data(true) # save and clear lock
    puts "Thank you for using extbrain. Have a good day!"
  end 
end

def command_loop
  $no_operation_count = 0
  if $log_command_usage
    unless $command_usage
      if File.exist?($data_file_command_usage)
        $command_usage = YAML.load(File.read($data_file_command_usage))
      else
        $command_usage = Hash.new
      end
    end 
  end

  while true
    print("extbrain> ")
    input = gets
    # TODO try $data.load_data BEFORE modifying state.
    # TODO scope lockfile to just save load
    unless RUBY_PLATFORM.include?('mingw') # windows 10 via rubyinstaller
      system('clear')
    end

    dispatch_user_input(input)
    # TODO make this configurable; agressively save data vs every 10 operations.. vs 100 vs only on save
    $data.save_data # disable this if it gets slow, but then you could lose data if session killed
  end
end

def dispatch_user_input(input_string)
  input_string.rstrip! # remove trailing whitespace, which is at minimum a newline
  three_pieces = input_string.split(' ',3)
  command = three_pieces[0]
  keyword = three_pieces[1]
  content = three_pieces[2]

  if $log_command_usage
    $command_usage[command] = $command_usage[command].to_i + 1 # increment, even if nil
  end
  case command
  # TODO TODO pt to add tags to projects, or just replace specify a new space seprated list?
  #   # lpw or wp = work projects
  # li / lm = list info (or metadata) with optional keyword for specific project
  when 'clear'
    system('clear')
  when 'co', 'lc', 'comp', 'computer', 'pc'
    view_or_add_task('computer', keyword, content)
  when 'c', 'com', 'complete', 'finish', 'done'
    edit_project_or_task('complete', keyword, content)
  when 'd', 'del', 'delete', 'remove', 'rm'
    edit_project_or_task('delete', keyword, content)
  when 'e', 'exit', 'q', 'quit', 'stop', 'bye'
    exit
  when 'f', 'fr', 'aof', 'aofr', 'afr', 'focus', 'resp'
    view_or_add_task('focus/resp', keyword, content)
  when 'g', 'go', 'goa', 'goal', 'goals'
    view_or_add_task('goals', keyword, content)
  when 'h', 'habit'
    habit_input(keyword, content)
  when 'ho', 'home', 'house', 'apartment', 'dorm', 'rv'
    view_or_add_task('home', keyword, content)
  when 'k', 'ki', 'kin', 'kindle', 'read', 'book'
    view_or_add_task('kindle', keyword, content)
  when 'lt', 'list-tasks'
    task_list(keyword)
  when 'lw'
    task_list('waiting')
  when 'j', 'lj'
    view_or_add_task('job', keyword, content)
  when 'jc', 'ljc'
    view_or_add_task('job-computer', keyword, content)
  when 'lp'
    $data.list_projects
  when 'lpj'
    project_input('job', nil)
  # TODO when lw work, lcomputer, lerrands, lagenda?
  when 'n', 'an', 'add-note', 'note'
    edit_project_or_task('add_note', keyword, content)
  when 'p', 'proj', 'project', 'projects'
    project_input(keyword, content)
  when 'pk', 'project-keyword'
    project_keyword(keyword, content)
  when 'pn', 'project notes'
    find_and_show_project(keyword, true)
  when 'pt', 'project-task'
    project_task(keyword, content)
  when 'psm', 'edit-psm', 'epsm'
    edit_project_or_task('edit_psm', keyword, content, true) # true = projects_only
  when 'pw' # pw keyword 'whatever I'm waiting on' - create project-specific waiting task
    project_task(keyword, 'waiting ' + content)
  when 'r', 'rename', 'retitle'
    edit_project_or_task('rename', keyword, content)
  when 's', 'search'
    search(keyword, content)
  when 'sm', 's/m', 'some', 'someday', 'may', 'maybe', 'someday/maybe'
    view_or_add_task('someday/maybe', keyword, content)
  when 'stat', 'st', 'stats'
    stats
  when 't', 'task'
    task_input(keyword, content)
  when 'undo'
    if $undo
      $undo[0].send($undo[1])
      puts 'Undo performed. Specifically did this: '
      puts "object: #{$undo[0]}"
      puts "action: #{$undo[1]}"
    else
      puts '$undo variable not set, nothing to undo?'
    end
  when 'w', 'wait', 'waiting'
    view_or_add_task('waiting', keyword, content)
  when 'wr', 'weekly review'
    weekly_review
  when '?', 'help', 'wtf'
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



def random_tip
  # todo stop once the create date of the first project is > 200 days from now.
  puts 'Tip of the day:'
  print ' '
  puts $tips.sample
end 


puts "Welcome to extbrain, version 1.3 (\"hello world\"), 2021-10-31"
# for the 1.2 release (only two bugs, and several features), the two bugs are: 
#puts "including \"don't kill me through PuTTY please!\" and \"date display issues at New Years\""
startup
# random_tip #annoying, 2020-12-18 
command_loop

