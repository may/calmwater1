# Created: 2020-06-06
# Revised: 2021-10-27
$log_command_usage_locally = true 
$save_directory = "#{Dir.home}/.extbrain"
$save_file = "#{$save_directory}/extbrain.yaml"
$lockfile = "#{$save_directory}/lockfile.txt" 

$archive_file = "#{$save_directory}/#{Time.now.year}_extbrain_completed_or_deleted.yaml"

$data_file_command_usage = "#{$save_directory}/command_usage.yaml"


# TODO rename to $color ? 10/27
$color_only = true # If perfer b&w, if colorblind, or if using Windows, set this to false.

$time_formatting_string = "%Y-%m-%d %H:%M, %A."

# Enable this if you want automatic context switching between work/home.
$time_sensitive_life_context = false

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


# If true, running a second session of extbrain on the same computer
# will kill the first session.
$take_over_lock = true

# for writing habits, calculate average word count for *evey* day since the habit
# was created, not just the days you wrote. Can be toggled back and forth if needed.
# Setting to true provides a more accurate picture of how much you *actually* write,
# instead of just counting the 'good' days where you write.
$use_zero_day_average = true 
