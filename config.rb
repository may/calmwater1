# Created: 2020-06-06
# Revised: 2020-02-03
$log_command_usage_locally = true 
$save_file_directory = "#{Dir.home}/.extbrain/"
$data_file_command_usage = "#{$save_directory}extbrain_command_usage.yaml"
$save_file_last_weekly_review_done = "#{Dir.home}#{$save_directory}/extbrain_last_weekly_review.yaml"

# Disable this if you don't work 8-5, or don't find automatic contexts useful. It's also adjustable, below.
$time_sensitive_life_context = true
# unix/linux/osx only w/ home
$save_file_habits = "#{Dir.home}#{$save_directory}/extbrain_habits.yaml"
$save_file_projects = "#{D ter
ir.home}#{$save_directory}/extbrain_projects.yaml"

$save_file_tasks = "#{Dir.home}#{$save_directory}/extbrain_tasks.yaml"
$lockfile = "#{Dir.home}#{$save_directory}/lockfile-extbrain.txt" # unix/linux/osx only?

$archive_file_projects = "#{Dir.home}#{$save_directory}/extbrain_#{Time.now.year}_projects_completed_or_deleted.yaml"
$archive_file_tasks = "#{Dir.home}#{$save_directory}/extbrain_#{Time.now.year}_non-project_tasks_completed_or_deleted.yaml"
$archive_file_habits = "#{Dir.home}#{$save_directory}/extbrain_#{Time.now.year}_habits_deleted.yaml"

$color_only = true # If perfer b&w, if colorblind, or if using Windows, set this to false.

$time_formatting_string = "%Y-%m-%d %H:%M, %A."

# This is only evaluated on inital launch of the program.
# May need to have it reevaluated hourly if long-running process on a single remote machine.
if $time_sensitive_life_context == true
  # 8am-5pm & M-F assume work
  if Time.now.wday.between?(1, 5) and Time.now.hour.between?(8, 16) 
    $life_context = :job
  else
    $life_context = :personal
  end
end

$take_over_lock = true

# for writing habits, calculate average word count for *evey* day since the habit
# was created, not just the days you wrote. Can be toggled back and forth if needed.
# Setting to true provides a more accurate picture of how much you *actually* write,
# instead of just counting the 'good' days where you write.
$use_zero_day_average = true 
