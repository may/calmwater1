# Created: 2020-06-06
# Revised: 2021-10-28
$log_command_usage_locally = true 
$save_directory = "#{Dir.home}/.extbrain"
$save_file = "#{$save_directory}/extbrain.yaml"
$lockfile = "#{$save_directory}/lockfile.txt" 

$archive_file = "#{$save_directory}/#{Time.now.year}_extbrain_completed_or_deleted.yaml"

$data_file_command_usage = "#{$save_directory}/command_usage.yaml"


# TODO rename to $color ? 10/27
$color_only = true # If perfer b&w, if colorblind, or if using Windows, set this to false.

$time_formatting_string = "%Y-%m-%d %H:%M, %A."


# If true, running a second session of extbrain on the same computer
# will kill the first session.
$take_over_lock = true

# for writing habits, calculate average word count for *evey* day since the habit
# was created, not just the days you wrote. Can be toggled back and forth if needed.
# Setting to true provides a more accurate picture of how much you *actually* write,
# instead of just counting the 'good' days where you write.
$use_zero_day_average = true 
