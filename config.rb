# Created: 2020-06-06
# Revised: 2020-07-21
$log_command_usage_locally = true
$data_file_command_usage = "#{Dir.home}/extbrain/extbrain_command_usage.yaml"


# Disable this if you don't work 8-5, or don't find automatic contexts useful. It's also adjustable, below.
$time_sensitive_life_context = true 
# unix/linux/osx only w/ home
$save_file_habits = "#{Dir.home}/extbrain/extbrain_habits.yaml"
$save_file_projects = "#{Dir.home}/extbrain/extbrain_projects.yaml"
$save_file_tasks = "#{Dir.home}/extbrain/extbrain_tasks.yaml"
$lockfile = "#{Dir.home}/extbrain/lockfile-extbrain.txt" # unix/linux/osx only?

$archive_file_projects = "extbrain_#{Time.now.year}_projects_completed_or_deleted.yaml"
$archive_file_tasks = "extbrain_#{Time.now.year}_non-project_tasks_completed_or_deleted.yaml"


$color_only = true # if you don't want to see text indicating *when* you last completed a habit. If colorblind, set this to false. If running Windows, set to false.

$time_formatting_string = "%Y-%m-%d %H:%M, %A."

# This is only evaluated on inital launch of the program.
# May need to have it reevaluated hourly if long-running process on a single remote machine.
if $time_sensitive_life_context == true
  # 8am-5pm & M-F assume work
  if Time.now.wday.between?(1, 5) and Time.now.hour.between?(8, 17) 
    $life_context = :job
  else
    $life_context = :personal
  end
end
